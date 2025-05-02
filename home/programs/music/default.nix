{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./go-musicfox.nix
  ];
  home = {
    packages = with pkgs; [
      mpc-cli
    ];
  };
  programs = {
    ncmpcpp = {
      enable = true;
      mpdMusicDir = null;
      settings = {
        mpd_music_dir = "~/Music";
      };
    };
    cava = {
      enable = true;
      settings = {
        color = {
          gradient = 1;
          gradient_count = 5;
          gradient_color_1 = "'#81A1C1'";
          gradient_color_2 = "'#8FBCBB'";
          gradient_color_3 = "'#B48EAD'";
          gradient_color_4 = "'#eceff4'";
          gradient_color_5 = "'#EBCB8B'";
        };
      };
    };
  };
  home.file = {
    # ".config/mpd/mpd.conf".text = import ./mpd.nix;
    # ".config/cava/config".source = ./cava_config;
    ".config/cava/config_internal".text = lib.mkIf (config.programs.cava.enable) ''
      [general]
      bars = 12
      sleep_timer = 10
      [output]
      method = raw
      data_format = ascii
      ascii_max_range = 7
    ''; # ../waybar/{share_scripts.nix}.config_internal;
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Music";
      network = {
        listenAddress = "0.0.0.0";
        port = 6600;
      };
      extraConfig = ''
          audio_output {
                  type            "pipewire"
                  name            "PipeWire Sound Server"
          }
          decoder {
                plugin "fluidsynth"
                soundfont "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
        }
      '';
    };
    fluidsynth = {
      enable = true;
      # soundFont = "";
      soundService = "pipewire-pulse";
    };
  };
}
