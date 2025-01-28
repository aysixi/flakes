{ pkgs, inputs, ... }:
{
  imports = [ ./config.nix ];
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      # inputs.hycov.packages.${pkgs.system}.hycov
    ];
    systemd.enable = true;
  };

  home = {
    packages = [
      # inputs.hyprland-contrib.packages."${pkgs.system}".grimblast
      # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
      # config.nur.repos.aleksana.yofi
    ] ++ (with pkgs; [
      grimblast
      hyprpicker
      # hyprlock
      # hypridle
      # swaylock-effects
      # swayidle
      pamixer
      # aegisub
    ]);
  };

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];

  home = {
    sessionVariables = {
      QT_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
