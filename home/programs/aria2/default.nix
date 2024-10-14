# ./bar.nix
{ user, ... }:
{
  imports = [
    ./options.nix
  ];

  services.aria2 = {
    enable = true;
    extraConfig = import ./aria2.nix { inherit user; };
  };
  xdg.configFile."aria2c".source = ./aria2;
}
