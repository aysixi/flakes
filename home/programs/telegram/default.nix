{ pkgs, config, ... }:
{
  home.packages = with pkgs;[
    telegram-desktop
  ];
}
