{ pkgs, ... }:
let
  keyjump = {
    yazi = {
      url = "https://raw.githubusercontent.com/redbeardymcgee/yazi-plugins/main/keyjump.yazi/init.lua";
      sha256 = "sha256-IP9GtFHxJWkW889fzqd4LogHjYE2ujk01/1ROP6KGMc=";
    };
  };
  keyjumpyazi = keyjump.yazi;
  keyjump-yazi = pkgs.fetchurl {
    inherit (keyjumpyazi) url sha256;
  };

  exifaudio = {
    yazi = {
      url = "https://raw.githubusercontent.com/sonico98/exifaudio.yazi/master/init.lua";
      sha256 = "sha256-4yyYAL/YrGun4r0oiMvEQ+kB/mPAvHzTy82WjEPzUm8=";
    };
  };
  exifaudio-yazi = pkgs.fetchurl {
    inherit (exifaudio.yazi) url sha256;
  };

  # mediainfo-yazi = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/Ape/mediainfo.yazi/master/init.lua";
  #   sha256 = "sha256-jUKG8MEQCBQ+/NIqNut5dkBxrUpAJ0Vd925XWIuqN/o=";
  # };

in
{
  programs.yazi = {
    enable = true;
    # package = yazi.packages.${pkgs.system}.default;
  };
  home.packages = with pkgs; [
    exiftool
    mediainfo
  ];
  home.file = {
    ".config/yazi/yazi.toml".source = ./yazi.toml;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/theme.toml".source = ./theme.toml;
    ".config/yazi/init.lua".source = ./init.lua;
    ".config/yazi/plugins/keyjump.yazi/init.lua".source = "${keyjump-yazi}";
    ".config/yazi/plugins/exifaudio.yazi/init.lua".source = "${exifaudio-yazi}";
    # ".config/yazi/plugins/mediainfo.yazi/init.lua".source = "${mediainfo-yazi}";
  };

}
