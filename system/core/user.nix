{
  pkgs,
  config,
  lib,
  mi,
  ...
}:
{
  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$y$j9T$KMe2e/BhNUJ/VnIZOMmhB/$.k0Js7115Jk8iZAGyNU2rK/AG16.56v7gk8bwrUp4i0";
  };
  programs.fish.enable = lib.mkIf (config.networking.hostName != "minimal") true;
  programs.git.enable = true;
  users.users.${mi.userName} = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$owwwWsfU9sj/Qa3D3VvXK0$paUL1d.oyIC5nejR0GMG/TMBsY0X5FHh5TrhprMzTd2";
    description = "${mi.userName}";
    shell = lib.mkIf (config.networking.hostName != "minimal") pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2DjjT8x2m75bd2M4ML8Uy7XXxaj5AzFvZKAqXWQTWZ nixos"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
  };
}
