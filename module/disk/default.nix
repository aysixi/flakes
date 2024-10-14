{ config, pkgs, lib, user, ... }:
let
  winmo = pkgs.writeShellScriptBin "winmo" ''
      if ! [ -f "/home/${user}/win/e" ]; then
      /run/current-system/sw/bin/mkdir -p /home/${user}/win/e 
      /run/current-system/sw/bin/mount -o rw /dev/disk/by-uuid/84C6DCB6C6DCAA26 /home/${user}/win/e
      else
      /run/current-system/sw/bin/mount -o rw /dev/disk/by-uuid/84C6DCB6C6DCAA26 /home/${user}/win/e
    fi
  '';
in
{
  systemd.services.ldmtool = {
    description = "Activate Windows Logical Disk Manager volumes";
    documentation = [ "man:ldmtool(1)" ];
    after = [ "network.target" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = "${pkgs.ldmtool}/bin/ldmtool create all";
    serviceConfig.ExecStop = "${pkgs.ldmtool}/bin/ldmtool remove all";

    wantedBy = [ "network.target" ];
  };


  systemd.services."ummm" = {
    description = "Mount /dev/sdb1 partition";
    wantedBy = [ "multi-user.target" ];
    after = [ "ldmtool.service" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.ExecStart = "${winmo}/bin/winmo";
    requires = [ "ldmtool.service" ];
  };

}
