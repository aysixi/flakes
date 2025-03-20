{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./security.nix
    ./user.nix
  ];

  programs.git.enable = true;

  programs.nix-ld.enable = true;

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

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [ fish ];
    systemPackages = with pkgs; [
      nix-tree
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
      nix-output-monitor
    ];
  };

  # programs.fish.enable = true;

  # services.xserver = {
  #   xkb.options = "caps:escape";
  # };
  # console.useXkbConfig = true;

  system.stateVersion = "23.11";
}
