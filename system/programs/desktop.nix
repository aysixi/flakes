{
  pkgs,
  config,
  mi,
  inputs,
  ...
}:
{
  programs = {
    dconf.enable = true;
  };

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [ pkgs.gnome-session ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons =
      with pkgs;
      [
        fcitx5-chinese-addons
        fcitx5-anthy
        fcitx5-table-extra
        fcitx5-rime
      ]
      ++ (with pkgs.aysixi; [
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ]);
  };

  environment = {
    systemPackages = with pkgs; [
      libnotify
      wl-clipboard
      xclip
      wlr-randr
      xorg.xeyes
      nemo
      wev
      wf-recorder
      pulsemixer
      sshpass
      imagemagick
      grim
      slurp
      linux-wifi-hotspot
      scrcpy
      qbittorrent-enhanced
      xwayland-satellite # niri need
      # inputs.noctalia.packages.${system}.default
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  programs.hyprland.enable = true;
  # programs.niri.enable = true;

  services.xserver = {
    # xkb.options = "caps:escape";
    # enable = true; #plasma5 config
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
  };
  console.useXkbConfig = true;

  programs = {
    light.enable = true;
  };
  services = {
    dbus.packages = [ pkgs.gcr ];
    # getty.autologinUser = "${mi.userName}";
    pipewire.audio.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${mi.userName} --noclear --keep-baud %I 115200,38400,9600 $TERM"
    ];
  };

  programs.adb.enable = true;
  users.users.${mi.userName}.extraGroups = [
    "adbuser"
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
