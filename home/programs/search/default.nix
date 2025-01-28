{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      fd
      bat
      ripgrep
    ];
    sessionVariables = {
      BAT_THEME = "mocha";
    };
    file.".config/bat/themes/mocha.tmTheme".source = ./mocha.tmTheme;
  };
  programs = {
    fzf.enable = true;
  };
}
