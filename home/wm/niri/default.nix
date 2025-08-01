{ pkgs, inputs, ... }:
{
  imports = [ ./config.nix ];

  xxx3.niri = {
    enable = true;
  };

  home = {
    packages = with pkgs; [
      # inputs.hyprland-contrib.packages."${pkgs.system}".grimblast
      # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
      # config.nur.repos.aleksana.yofi
      pamixer
    ];
  };

  home = {
    sessionVariables = {
      QT_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
    };
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

}
