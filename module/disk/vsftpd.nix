{ config, pkgs, ... }:
{
  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1042;
        to = 1042;
      }
    ];
  };
  services.vsftpd = {
    enable = false;
    localUsers = true;
    writeEnable = true;
    chrootlocalUser = true;
    extraConfig = ''
      listen_port=1042
    '';
  };
}
