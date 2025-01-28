{ pkgs, ... }:
let
  settings = import ./yazi.nix;
  theme = import ./theme.nix;
  keymap = import ./keymap.nix;
in
{
  programs.yazi = {
    enable = true;
    initLua = ./init.lua; #This plugin provides cross-instance yank ability
    enableFishIntegration = true;
    # shellWrapperName = "r"; #use functions
    flavors = { };
    plugins = {
      exifaudio = pkgs.exifaudio-yazi;
    };
    settings = settings;
    # theme = theme;
    keymap = keymap;
  };

  home.packages = with pkgs; [
    exiftool
    mediainfo
  ];
}
