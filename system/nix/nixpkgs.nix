{ self
, pkgs
, inputs
, ...
}:
{
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
      self.overlays.default
      inputs.yazi.overlays.default
      inputs.rust-overlay.overlays.default

      (final: prev: {
        aysixi = inputs.aysixi.packages."${prev.system}";
      })

      (_: prev: {
        gamescope = prev.gamescope.overrideAttrs (_: rec {
          version = "3.14.29";
          src = prev.fetchFromGitHub {
            owner = "ValveSoftware";
            repo = "gamescope";
            rev = "refs/tags/${version}";
            fetchSubmodules = true;
            hash = "sha256-q3HEbFqUeNczKYUlou+quxawCTjpM5JNLrML84tZVYE=";
          };
        });
      })

      (final: prev: {
        fcitx5-rime = prev.fcitx5-rime.override {
          rimeDataPkgs = with pkgs.aysixi;
            [
              rime-icea
            ];
        };
      })
    ];
  };
}
