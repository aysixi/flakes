{
  config,
  inputs,
  lib,
  mi,
  ...
}:
{
  #NOTE: https://github.com/Mic92/sops-nix#initrd-secrets
  sops = {
    defaultSopsFile = "${inputs.aysixi-sec}/secrets/secrets.yaml";
    gnupg.sshKeyPaths = [ ];
    age = {
      sshKeyPaths = [ ];
      keyFile = "/var/lib/sops-nix/keys.txt"; # You must back up this keyFile yourself
      generateKey = true;
    };
    secrets = {
      rclone = {
        mode = "0600";
        owner = "${mi.userName}";
        path = "/home/" + "${mi.userName}" + "/.config/rclone/rclone.con";
      };
      sshkey = {
        mode = "0600";
        owner = "${mi.userName}";
        path = "/home/" + "${mi.userName}" + "/.ssh/openwrt";
      };
    };
  };
  # issue: https://github.com/Mic92/sops-nix/issues/149
  # workaround:
  systemd.services.decrypt-sops = {
    description = "Decrypt sops secrets";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "2s";
    };
    script = config.system.activationScripts.setupSecrets.text;
  };
}
