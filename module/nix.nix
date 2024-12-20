{ self, pkgs, inputs, lib, ... }:
{
  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      nix-path = lib.mkForce "nixpkgs=flake:nixpkgs";
      experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" "configurable-impure-env" "cgroups" ];
      auto-allocate-uids = true;
      use-cgroups = true;
      auto-optimise-store = true; # Optimise syslinks
      accept-flake-config = true;
      flake-registry = "${inputs.flake-registry}/flake-registry.json";
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
      substituters = [
        "https://nix-community.cachix.org"
        # "https://hyprland.cachix.org"
        "https://ruixi-rebirth.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "ruixi-rebirth.cachix.org-1:sWs3V+BlPi67MpNmP8K4zlA3jhPCAvsnLKi4uXsiLI4="
      ];
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.git;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      keep-outputs            = true
      keep-derivations        = true
    '';
  };

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
