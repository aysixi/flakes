{
  lib,
  pkgs,
  user,
  ...
}:
{
  networking.hostName = "wsl";

  wsl = {
    enable = true;
    defaultUser = user;
    useWindowsDriver = true;
    nativeSystemd = true;
  };

  environment = {
    systemPackages = with pkgs; [
      clipboard-jh
      fastfetch
    ];
  };

  sops = {
    secrets.sshkey = {
      mode = "0600";
      owner = "${user}";
      path = "/home/" + "${user}" + "/.ssh/openwrt";
    };
  };

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
