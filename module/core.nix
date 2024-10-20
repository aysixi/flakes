{ pkgs, user, config, inputs, lib, ... }:
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

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
      LANGUAGE = "ja_JP.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "C.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
      "zh_SG.UTF-8/UTF-8"
    ];
  };

  services.resolved.enable = true;
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall = {
      allowedTCPPorts = [
        6600
        # 47984
        # 47989
        # 47990
        # 48010
      ];
      allowedUDPPortRanges = [
        # { from = 47998; to = 48000; }
        # { from = 8000; to = 8010; }
      ];
    };
    hosts = {
      "127.0.0.1" = [ "misskey.lan" ];
      "185.199.109.133" = [ "raw.githubusercontent.com" ];
      "185.199.111.133" = [ "raw.githubusercontent.com" ];
      "185.199.110.133" = [ "raw.githubusercontent.com" ];
      "185.199.108.133" = [ "raw.githubusercontent.com" ];
      "192.168.1.198" = [
        "firefox.com.cn"
        "download-ssl.firefox.com.cn"
        "firefoxchina.cn"
        "home.firefoxchina.cn"
        "start.firefoxchina.cn"
        "flash.cn"
        "directads.mcafee.com"
        "ads.mcafee.com"
      ];
    };
  };

  services = {
    openssh = {
      ports = [ 25566 ];
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no"; # disable root login
        PasswordAuthentication = false; # disable password login
      };
      openFirewall = true;
    };
    dbus.enable = true;
  };

  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$y$j9T$KMe2e/BhNUJ/VnIZOMmhB/$.k0Js7115Jk8iZAGyNU2rK/AG16.56v7gk8bwrUp4i0";
  };
  programs.fish.enable = lib.mkIf (config.networking.hostName != "minimal") true;
  programs.git.enable = true;
  users.users.${user} = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$owwwWsfU9sj/Qa3D3VvXK0$paUL1d.oyIC5nejR0GMG/TMBsY0X5FHh5TrhprMzTd2";
    description = "${user}";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5gMaeV2ehMMUMd7jbIHT4PXCSGkYv7A0WiseMymMoP yuki"
    ];
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        ${user} ALL=(ALL) NOPASSWD:ALL
      '';
    };
    doas = {
      enable = true;
      extraConfig = ''
        permit nopass :wheel
      '';
    };
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [ fish ];
    systemPackages = with pkgs; [
      gcc
      clang
      gdb
      neovim
      wget
      neofetch
      eza
      p7zip
      atool
      unzip
      zip
      rar
      ffmpeg
      xdg-utils
      pciutils
      killall
      socat
      sops
      lsof
    ];
  };

  system.stateVersion = "23.11";

}
