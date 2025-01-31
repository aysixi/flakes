# ./bar.nix
{
  mi,
  lib,
  config,
  ...
}:
{
  imports = [
    ./options.nix
  ];

  services.aria2 = {
    enable = true;
    extraConfig = import ./aria2.nix { inherit mi; };
  };

  home.activation = lib.mkIf (config.services.aria2.enable) {
    copyAria2Files = ''
      cp -r ${./aria2} /home/${mi.userName}/.config/aria2c
      chmod -R u+w /home/${mi.userName}/.config/aria2c/
    '';
  };
  # xdg.configFile."aria2c".source = ./aria2;
}
