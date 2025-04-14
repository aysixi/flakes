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
      OPENAI_API_KEY = {
        owner = "${mi.userName}";
      };
      CACHIX_AUTH_TOKEN = {
        owner = "${mi.userName}";
      };
      GITHUB_TOKEN = {
        owner = "${mi.userName}";
      };
      NIX_ACCESS_TOKENS = {
        owner = "${mi.userName}";
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

  programs.fish = lib.mkIf config.programs.fish.enable {
    shellInit = ''
      export OPENAI_API_KEY="$(cat ${config.sops.secrets.OPENAI_API_KEY.path})"
      export CACHIX_AUTH_TOKEN="$(cat ${config.sops.secrets.CACHIX_AUTH_TOKEN.path})"
      export GITHUB_TOKEN="$(cat ${config.sops.secrets.GITHUB_TOKEN.path})"
      export NIX_ACCESS_TOKENS="$(cat ${config.sops.secrets.NIX_ACCESS_TOKENS.path})"
    '';
  };

}
