{ pkgs, lib, config, ... }:
{
  boot = {
    supportedFilesystems = [ "ntfs" ]; #ntfs support
    bootspec.enable = true;
    loader = {
      systemd-boot =
        if !config.boot.lanzaboote.enable then {
          enable = true;
          consoleMode = "auto";
          # configurationLimit = "5";
        } else {
          enable = lib.mkForce false;
        };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
  environment.systemPackages = [ pkgs.sbctl ];
}
