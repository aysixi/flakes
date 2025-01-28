{ config, pkgs, lib, ... }:
{
  sops.secrets."config.json".mode = "0744";
  services.xray = {
    enable = true;
    settingsFile = config.sops.secrets."config.json".path;
  };
}
