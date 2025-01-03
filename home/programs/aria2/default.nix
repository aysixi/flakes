# ./bar.nix
{ user, lib, config, ... }:
{
  imports = [
    ./options.nix
  ];

  services.aria2 = {
    enable = true;
    extraConfig = import ./aria2.nix { inherit user; };
  };

  home.activation = lib.mkIf (config.services.aria2.enable) {
    copyAria2Files = ''
      cp -r ${./aria2} /home/${user}/.config/aria2c
      chmod -R u+w /home/${user}/.config/aria2c/
    '';
  };
  # xdg.configFile."aria2c".source = ./aria2;
}
