{ pkgs, ... }:
{
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    fuzzel = {
      enable = true;
      settings = {
        colors = {
          background = "1e1e2edd";
          text = "cdd6f4ff";
          prompt = "bac2deff";
          placeholder = "7f849cff";
          input = "cdd6f4ff";
          match = "f5c2e7ff";
          selection = "585b70ff";
          selection-text = "cdd6f4ff";
          selection-match = "f5c2e7ff";
          counter = "7f849cff";
          border = "f5c2e7ff";
        };
      };
    };
  };
  home.file = {
    ".config/rofi/off.sh".source = ./off.sh;
    ".config/rofi/launcher.sh".source = ./launcher.sh;
    ".config/rofi/launcher_theme.rasi".source = ./launcher_theme.rasi;
    ".config/rofi/powermenu.sh".source = ./powermenu.sh;
    ".config/rofi/powermenu_theme.rasi".source = ./powermenu_theme.rasi;
  };
}
