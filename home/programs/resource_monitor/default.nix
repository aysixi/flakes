{ pkgs, ... }:
{
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "mocha";
      };
    };
  };
  home.file = {
    ".config/btop/themes/mocha.theme".source = ./theme.nix;
  };
}
