{ pkgs, ... }:

let
  watermark = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Ruixi-rebirth/someSource/main/watermark/watermark1.png";
    sha256 = "sha256-FUVSKKNv594jaAJGF+m622TkHB+Wwvyewd11WzXbjcQ=";
  };
  grimblast_watermark = pkgs.writeShellScriptBin "grimblast_watermark" ''
    FILE=$(date "+%Y-%m-%d"T"%H:%M:%S").png
    # Get the picture from maim
    grimblast --notify --cursor save area $HOME/Pictures/src.png >> /dev/null 2>&1
    # add shadow, round corner, border and watermark
    convert $HOME/Pictures/src.png \
    \( +clone -alpha extract \
    -draw 'fill black polygon 0,0 0,8 8,0 fill white circle 8,8 8,0' \
    \( +clone -flip \) -compose Multiply -composite \
    \( +clone -flop \) -compose Multiply -composite \
    \) -alpha off -compose CopyOpacity -composite $HOME/Pictures/output.png
    #
    convert $HOME/Pictures/output.png -bordercolor none -border 20 \( +clone -background black -shadow 80x8+15+15 \) \
    +swap -background transparent -layers merge +repage $HOME/Pictures/$FILE
    #
    composite -gravity Southeast "${watermark}" $HOME/Pictures/$FILE $HOME/Pictures/$FILE
    #
    wl-copy < $HOME/Pictures/$FILE
    #   remove the other pictures
    rm $HOME/Pictures/src.png $HOME/Pictures/output.png
  '';
  launch_waybar = pkgs.writeShellScriptBin "launch_waybar" ''
    killall .waybar-wrapped
    ${pkgs.waybar}/bin/waybar > /dev/null 2>&1 &
  '';
in
{
  imports = [ ../../programs/waybar/hyprland_waybar.nix ];
  wayland.windowManager.hyprland = {
    extraConfig = ''
      $mainMod = ALT
      # $scripts=$HOME/.config/hypr/scripts

      monitor=,preferred,auto,1
      # monitor=HDMI-A-1, 1920x1080, 0x0, 1
      # monitor=eDP-1, 1920x1080, 1920x0, 1

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options = caps:escape
        kb_rules =
        accel_profile = flat

        follow_mouse = 2 # 0|1|2|3
        float_switch_override_focus = 2
        numlock_by_default = true

      touchpad {
        natural_scroll = yes
      }

      touchdevice {
        transform = 2
      }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
        gaps_in = 3
        gaps_out = 5
        border_size = 3
        col.active_border = rgb(81a1c1)
        col.inactive_border = rgba(595959aa)

        layout = dwindle # master|dwindle
      }

      dwindle {
        force_split = 0
        special_scale_factor = 0.8
        split_width_multiplier = 1.0
        use_active_for_splits = true
        pseudotile = yes
        preserve_split = yes
      }

      master {
        new_status = true
        special_scale_factor = 0.8
        new_status = true
      }

      # cursor_inactive_timeout = 0
      decoration {
        rounding = 0
        active_opacity = 1.0
        inactive_opacity = 1.0
        fullscreen_opacity = 1.0
        shadow {
        enabled = false
        range = 4
        render_power = 3
        ignore_window = true
        color = 0x1a1a1aee
      }
      # col.shadow =
      # col.shadow_inactive
      # shadow_offset
        dim_inactive = false
      # dim_strength = #0.0 ~ 1.0

        blur {
          enabled = true
          size = 3
          passes = 1
          new_optimizations = true
          xray = true
          ignore_opacity = false
        }
      }

      animations {
        enabled=1
        bezier = overshot, 0.13, 0.99, 0.29, 1.1
        animation = windows, 1, 4, overshot, slide
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 5, default
        animation = fade, 1, 8, default
        animation = workspaces, 1, 6, overshot, slidevert
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 4
        workspace_swipe_distance = 250
        workspace_swipe_invert = true
        workspace_swipe_min_speed_to_force = 15
        workspace_swipe_cancel_ratio = 0.5
        workspace_swipe_create_new = false
      }

      misc {
        disable_autoreload = true
        disable_hyprland_logo = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        enable_swallow = true
        swallow_regex =
        focus_on_activate = true
      }

      device {
        name = epic mouse V1
        sensitivity = -0.5
      }

      #---------#
      # plugins #
      #---------#
      bind = $mainMod, Return, exec, kitty
      bind = $mainMod SHIFT, Return, exec, kitty --class="termfloat"
      bind = $mainMod SHIFT, P, killactive,
      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod SHIFT, Space, togglefloating,
      bind = $mainMod,F,fullscreen
      bind = $mainMod,Y,pin
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle

      #-----------------------#
      # Toggle grouped layout #
      #-----------------------
      bind = $mainMod, K, togglegroup,
      bind = $mainMod, Tab, changegroupactive, f

      #------------#
      # change gap #
      #------------#
      bind = $mainMod SHIFT, G,exec,hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"
      bind = $mainMod , G,exec,hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"

      #--------------------------------------#
      # Move focus with mainMod + arrow keys #
      #--------------------------------------#
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      #----------------------------------------#
      # Switch workspaces with mainMod + [0-9] #
      #----------------------------------------#
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      bind = $mainMod, L, workspace, +1
      bind = $mainMod, H, workspace, -1
      bind = $mainMod, period, workspace, e+1
      bind = $mainMod, comma, workspace,e-1
      bind = $mainMod, M, workspace,MU
      bind = $mainMod, Q, workspace,CH
      bind = $mainMod, S, workspace,ST

      #-------------------------------#
      # special workspace(scratchpad) #
      #-------------------------------#
      bind = $mainMod, minus, movetoworkspace,special
      bind = $mainMod, equal, togglespecialworkspace

      #----------------------------------#
      # move window in current workspace #
      #----------------------------------#
      bind = $mainMod SHIFT,left ,movewindow, l
      bind = $mainMod SHIFT,right ,movewindow, r
      bind = $mainMod SHIFT,up ,movewindow, u
      bind = $mainMod SHIFT,down ,movewindow, d

      #---------------------------------------------------------------#
      # Move active window to a workspace with mainMod + ctrl + [0-9] #
      #---------------------------------------------------------------#
      bind = $mainMod CTRL, 1, movetoworkspace, 1
      bind = $mainMod CTRL, 2, movetoworkspace, 2
      bind = $mainMod CTRL, 3, movetoworkspace, 3
      bind = $mainMod CTRL, 4, movetoworkspace, 4
      bind = $mainMod CTRL, 5, movetoworkspace, 5
      bind = $mainMod CTRL, 6, movetoworkspace, 6
      bind = $mainMod CTRL, 7, movetoworkspace, 7
      bind = $mainMod CTRL, 8, movetoworkspace, 8
      bind = $mainMod CTRL, 9, movetoworkspace, 9
      bind = $mainMod CTRL, 0, movetoworkspace, 10
      bind = $mainMod CTRL, left, movetoworkspace, -1
      bind = $mainMod CTRL, right, movetoworkspace, +1
      # same as above, but doesnt switch to the workspace
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10
      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      #-------------------------------------------#
      # switch between current and last workspace #
      #-------------------------------------------#
      binds {
      workspace_back_and_forth = 1
      allow_workspace_cycles = 1
      }
      bind=$mainMod,slash,workspace,previous

      #------------------------#
      # quickly launch program #
      #------------------------#
      bind=$mainMod,B,exec,nvidia-offload firefox
      bind=$mainMod SHIFT,R,exec,hyprctl reload
      bind=$mainMod SHIFT,M,exec,kitty --class="musicfox" --hold sh -c "musicfox"
      bind=$mainMod SHIFT,D,exec,kitty  --class="danmufloat" --hold sh -c "export TERM=xterm-256color && bili"
      bind=$mainMod SHIFT,X,exec,hyprlock
      bind=$mainMod,T,exec,Telegram
      bind = $mainMod,W,exec,bottles-cli run -p sai2 -b 'sai2' -- %u
      bind=$mainMod,bracketleft,exec,grimblast --notify --cursor  copysave area ~/Pictures/$(date "+%Y-%m-%d"T"%H:%M:%S_no_watermark").png
      bind=$mainMod,bracketright,exec, grimblast --notify --cursor  copy area
      bind=$mainMod,A,exec, ${grimblast_watermark}/bin/grimblast_watermark
      bind=,Super_L,exec, pkill rofi || ~/.config/rofi/launcher.sh
      bind=$mainMod,Super_L,exec, bash ~/.config/rofi/powermenu.sh

      #-----------------------------------------#
      # control volume,brightness,media players-#
      #-----------------------------------------#
      bind=,XF86AudioRaiseVolume,exec, pamixer -i 5
      bind=,XF86AudioLowerVolume,exec, pamixer -d 5
      bind=,XF86AudioMute,exec, pamixer -t
      bind=,XF86AudioMicMute,exec, pamixer --default-source -t
      bind=,XF86MonBrightnessUp,exec, light -A 5
      bind=,XF86MonBrightnessDown, exec, light -U 5
      bind=,XF86AudioPlay,exec, mpc -q toggle
      bind=,XF86AudioNext,exec, mpc -q next
      bind=,XF86AudioPrev,exec, mpc -q prev

      #---------------#
      # waybar toggle #
      # --------------#
      bind=$mainMod,O,exec,killall -SIGUSR1 .waybar-wrapped

      #---------------#
      # resize window #
      #---------------#
      bind=ALT,R,submap,resize
      submap=resize
      binde=,right,resizeactive,15 0
      binde=,left,resizeactive,-15 0
      binde=,up,resizeactive,0 -15
      binde=,down,resizeactive,0 15
      binde=,l,resizeactive,15 0
      binde=,h,resizeactive,-15 0
      binde=,k,resizeactive,0 -15
      binde=,j,resizeactive,0 15
      bind=,escape,submap,reset
      submap=reset

      #-----------#
      # minecraft #
      #-----------#
      binde=ALT,F12,submap,mine
      submap=mine
      bind=ALT,F12,submap,reset
      submap=reset


      bind=CTRL SHIFT, left, resizeactive,-15 0
      bind=CTRL SHIFT, right, resizeactive,15 0
      bind=CTRL SHIFT, up, resizeactive,0 -15
      bind=CTRL SHIFT, down, resizeactive,0 15
      bind=CTRL SHIFT, l, resizeactive, 15 0
      bind=CTRL SHIFT, h, resizeactive,-15 0
      bind=CTRL SHIFT, k, resizeactive, 0 -15
      bind=CTRL SHIFT, j, resizeactive, 0 15

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      #-----------------------#
      # wall(by swww service) #
      #-----------------------#
      # exec-once = default_wall

      #------------#
      # auto start #
      #------------#
      exec-once = ${launch_waybar}/bin/launch_waybar &
      exec-once = nm-applet &
      exec-once = mako &
      exec-once = mpd &
      exec-once = hypridle

      #---------------#
      # windows rules #
      #---------------#
      #`hyprctl clients` get class、title...
      windowrule=float,title:^(Picture-in-Picture)$
      windowrule=size 960 540,title:^(Picture-in-Picture)$
      windowrule=move 25%-,title:^(Picture-in-Picture)$
      windowrule=float,class:imv
      windowrule=move 25%-,class:imv
      windowrule=size 960 540,class:imv
      windowrule=float,class:mpv
      windowrule=move 25%-,class:mpv
      windowrule=size 960 540,class:mpv
      windowrule=float,class:danmufloat
      windowrule=move 25%-,class:danmufloat
      windowrule=pin,class:danmufloat
      windowrule=rounding 5,class:danmufloat
      windowrule=size 960 540,class:danmufloat
      windowrule=float,class:termfloat
      windowrule=move 25%-,class:termfloat
      windowrule=size 960 540,class:termfloat
      windowrule=rounding 5,class:termfloat
      windowrule=float,class:nemo
      windowrule=move 25%-,class:nemo
      windowrule=size 960 540,class:nemo
      windowrulev2=opacity 0.95,class:org.telegram.desktop
      windowrule=animation slide right,class:kitty
      windowrulev2=workspace name:CH,class:org.telegram.desktop
      windowrule=workspace name:MU,class:musicfox
      windowrule=workspace name:CH, class:firefox
      windowrule=workspace name:ST, class:steam
      windowrule=float,class:ncmpcpp
      windowrule=move 25%-,class:ncmpcpp
      windowrule=size 960 540,class:ncmpcpp
      windowrule=noblur,class:^(firefox)$
      windowrulev2=maximize, class:sai2.exe, title:(.*)PaintTool(.*)
      windowrulev2=workspace name:絵, class:sai2.exe
      windowrulev2=size 960 540, class:sai2.exe, title:(.*)新建画布

      #-----------------#
      # workspace rules #
      #-----------------#
      workspace=HDMI-A-1,10
    '';
  };
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      source = ${./mocha.conf}

      $accent = $mauve
      $accentAlpha = $mauveAlpha
      $font = JetBrainsMono Nerd Font

      # GENERAL
      general {
        disable_loading_bar = true
        hide_cursor = true
      }

      # BACKGROUND
      background {
        monitor =
        path = $HOME/Pictures/wallpaper/hyprlock.png
        blur_passes = 0
        color = $base
      }

      # LAYOUT
      label {
        monitor =
        text = Layout: $LAYOUT
        color = $text
        font_size = 25
        font_family = $font
        position = 30, -30
        halign = left
        valign = top
      }

      # TIME
      label {
        monitor =
        text = $TIME
        color = $text
        font_size = 90
        font_family = $font
        position = -30, 0
        halign = right
        valign = top
      }

      # DATE
      label {
        monitor =
        text = cmd[update:43200000] date +"%A, %d %B %Y"
        color = $text
        font_size = 25
        font_family = $font
        position = -30, -150
        halign = right
        valign = top
      }

      # USER AVATAR
      image {
        monitor =
        path = $HOME/Pictures/android-picture/pixez/91409392_p0.jpg
        size = 100
        border_color = $accent
        position = 0, 75
        halign = center
        valign = center
      }

      # INPUT FIELD
      input-field {
        monitor =
        size = 300, 60
        outline_thickness = 4
        dots_size = 0.2
        dots_spacing = 0.2
        dots_center = true
        outer_color = $accent
        inner_color = $surface0
        font_color = $text
        fade_on_empty = false
        placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
        hide_input = false
        check_color = $accent
        fail_color = $red
        fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
        capslock_color = $yellow
        position = 0, -47
        halign = center
        valign = center
      }
    '';
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 630;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1200;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
