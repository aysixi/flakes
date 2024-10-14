{ config, daeuniverse, lib, pkgs, inputs, user, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
