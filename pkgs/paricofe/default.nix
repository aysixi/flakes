{
  stdenv,
  lib,
  nixosTests,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  makeWrapper,
  python3,
  bash,
  jemalloc,
  ffmpeg-headless,
  writeShellScript,
  xcbuild,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paricofe";

  version = "2025.6.3-pari.11";

  src = fetchFromGitHub {
    owner = "aysixi";
    repo = "misskey";
    rev = "refs/heads/pari";
    hash = "sha256-ZUy6gcbt1huCGzWC5kKod7a2VXBrlfRLoXocd+Ozu8c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    makeWrapper
    python3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcrun ];
  # https://nixos.org/manual/nixpkgs/unstable/#javascript-pnpm
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yQ7HSCeMDd9uMxNuMJpQztUJ4E4ynrRIgCFIY1mu2QE=";
  };

  buildPhase = ''
    runHook preBuild


    # https://github.com/NixOS/nixpkgs/pull/296697/files#r1617546739
    (
      cd node_modules/.pnpm/node_modules/v-code-diff
      pnpm run postinstall
    )

    # https://github.com/NixOS/nixpkgs/pull/296697/files#r1617595593
    export npm_config_nodedir=${nodejs}
    (
      cd node_modules/.pnpm/node_modules/re2
      pnpm run rebuild
    )
    (
      cd node_modules/.pnpm/node_modules/sharp
      pnpm run install
    )

    pnpm build

    runHook postBuild
  '';

  installPhase =
    let
      checkEnvVarScript = writeShellScript "misskey-check-env-var" ''
        if [[ -z $MISSKEY_CONFIG_YML ]]; then
          echo "MISSKEY_CONFIG_YML must be set to the location of the Misskey config file."
          exit 1
        fi
      '';
    in
    ''
      runHook preInstall

      mkdir -p $out/data
      cp -r . $out/data

      # Set up symlink for use at runtime
      # TODO: Find a better solution for this (potentially patch Misskey to make this configurable?)
      # Line that would need to be patched: https://github.com/misskey-dev/misskey/blob/9849aab40283cbde2184e74d4795aec8ef8ccba3/packages/backend/src/core/InternalStorageService.ts#L18
      # Otherwise, maybe somehow bindmount a writable directory into <package>/data/files.
      ln -s /var/lib/misskey $out/data/files

      makeWrapper ${pnpm_9}/bin/pnpm $out/bin/misskey \
        --run "${checkEnvVarScript} || exit" \
        --chdir $out/data \
        --add-flags run \
        --set-default NODE_ENV production \
        --prefix PATH : ${
          lib.makeBinPath [
            nodejs
            pnpm_9
            bash
          ]
        } \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            jemalloc
            ffmpeg-headless
            stdenv.cc.cc
          ]
        }

      runHook postInstall
    '';

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    tests.misskey = nixosTests.misskey;
  };

  meta = {
    description = "🌎 An interplanetary microblogging platform 🚀";
    homepage = "https://misskey-hub.net/";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.feathecutie ];
    platforms = lib.platforms.unix;
    mainProgram = "misskey";
  };
})
