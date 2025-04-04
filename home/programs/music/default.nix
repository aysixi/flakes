{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      cava
      mpc-cli
      go-musicfox
    ];
  };
  programs = {
    ncmpcpp = {
      enable = true;
      mpdMusicDir = null;
    };
  };
  home.file = {
    ".config/ncmpcpp/config".text = ''
      mpd_music_dir = ~/Music
    '';
    # ".config/mpd/mpd.conf".text = import ./mpd.nix;
    ".config/cava/config".source = ./cava_config;
    ".config/cava/config_internal".source = ./cava_config_internal;
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
