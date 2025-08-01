{
  config,
  lib,
  pkgs,
  ...
}:

let
  niriConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;

    let
      cfg = config.xxx3.niri;
    in
    {
      options.xxx3.niri = {
        enable = mkEnableOption "the niri program";

        extraConfig = mkOption {
          default = "";
          example = ''
            xxxx
          '';
          type = types.lines;
          description = ''
            config for niri
          '';
        };
        # systemd = mkOption {
        #   type = types.unspecified;
        #   default = { };
        #   description = "Dummy field to satisfy external references.";
        # };
      };

      config = mkIf cfg.enable {
        xdg.configFile."niri/config.kdl" = mkIf (cfg.extraConfig != "") {
          text = ''
            // home-manager
            ${cfg.extraConfig}
          '';
        };
      };
    };

  launch_waybar = pkgs.writeShellScriptBin "launch_waybar" ''
    killall .waybar-wrapped
    ${pkgs.waybar}/bin/waybar > /dev/null 2>&1 &
  '';
in
{

  imports = [
    niriConfig
    ../../programs/waybar/niri_waybar.nix
  ];

  xxx3.niri = {
    extraConfig = ''
      input {
          mod-key "Alt"
          keyboard {
              xkb {
                  layout "us"
                  options "caps:escape"
              }
              numlock
          }
          touchpad {
              tap
              natural-scroll
              accel-profile "flat"
          }
          mouse {
              accel-speed 0.2
              accel-profile "flat"
          }
          trackpoint {
              accel-profile "flat"
          }
          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="0%"
      }
      layout {
          gaps 16
          center-focused-column "never"
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }
          default-column-width { proportion 0.5; }
          focus-ring {
              width 4
              active-color "#7fc8ff"
              inactive-color "#505050"
          }
          border {
              off
              width 4
              active-color "#ffc87f"
              inactive-color "#505050"
              urgent-color "#9b0000"
          }
          shadow {
              softness 30
              spread 5
              offset x=0 y=5
              color "#0007"
          }
          struts {
          }
      }
      spawn-at-startup "waybar"
      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "/nix/store/53idfkc8nx5wy09nr1m49i4q3lvvwnl9-launch_waybar/bin/launch_waybar &"
      spawn-at-startup "mako"

      environment {
          DISPLAY ":0"
      }
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
      animations {
      }
      window-rule {
          open-maximized true
      }
      window-rule {
          match app-id=r#"^org\.wezfurlong\.wezterm$"#
          default-column-width {}
      }
      window-rule {
          match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
          default-floating-position x=10 y=10 relative-to="bottom-right"
      }
      window-rule {
          match app-id=r#"firefox$"# title="^Picture-in-Picture$"
          open-floating true
      }
      /-window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#
          block-out-from "screen-capture"
      }
      /-window-rule {
          geometry-corner-radius 12
          clip-to-geometry true
      }
      window-rule {
        match app-id="mpv"
        match app-id="ncmpcpp"
        match app-id="termfloat"
        open-floating true
        // Anchor to the top edge of the screen.
        default-floating-position x=180 y=50 relative-to="bottom"
        min-width 960
        max-width 960
        min-height 540
        max-height 540
      }
      window-rule {
        # match app-id="kitty"
        open-maximized false
      }
      window-rule {
        match app-id="firefox"
        open-maximized true
      }
      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+Return { spawn "kitty"; }
          Mod+Shift+Return { spawn "kitty" "--class=termfloat"; }
          Mod+T { spawn "Telegram"; }

          Mod+Shift+X { spawn "hyprlock"; }

          Mod+Super_L { spawn "bash" "-c" "~/.config/rofi/powermenu.sh"; }
          Super+Super_L { spawn "bash" "-c" "pkill rofi || ~/.config/rofi/launcher.sh"; }


          XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
          Mod+O repeat=false { toggle-overview; }
          Mod+Shift+P { close-window; }
          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }
          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+J     { move-window-down; }
          Mod+Ctrl+K     { move-window-up; }
          Mod+Ctrl+L     { move-column-right; }
          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }
          Mod+Shift+Left  { focus-monitor-left; }
          Mod+Shift+Down  { focus-monitor-down; }
          Mod+Shift+Up    { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }
          Mod+Shift+H     { focus-monitor-left; }
          Mod+Shift+J     { focus-monitor-down; }
          Mod+Shift+K     { focus-monitor-up; }
          Mod+Shift+L     { focus-monitor-right; }
          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+I              { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }
          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }
          Mod+Shift+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+Shift+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }
          Mod+WheelScrollDown      { focus-column-right; }
          Mod+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }
          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Q { focus-workspace "CH"; }
          Mod+S { focus-workspace "ST"; }
          Mod+Tab { focus-workspace-previous; }
          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }
          Mod+Comma  { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }
          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Ctrl+F { expand-column-to-available-width; }
          Mod+C { center-column; }
          Mod+Ctrl+C { center-visible-columns; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }
          Mod+V       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }
          Mod+W { toggle-column-tabbed-display; }
          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          Mod+Shift+Q { quit skip-confirmation=true; }
      }

    '';
  };
}
