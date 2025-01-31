{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "exifaudio-yazi";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "sonico98";
    repo = "exifaudio.yazi";
    rev = "d7946141c87a23dcc6fb3b2730a287faf3154593";
    sha256 = "sha256-nXBxPG6PVi5vstvVMn8dtnelfCa329CTIOCdXruOxT4=";
  };
  installPhase = ''
    mkdir -p $out/
    cp -r $src/* $out/
    # mv $out/init.lua $out/main.lua 
  '';
  meta = {
    description = "yazi plugin";
    homepage = "";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.null ];
  };
}
