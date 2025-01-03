{ config, pkgs, ... }:

{
  # home.file.".config/mako/config".text = ''
  #   max-visible=5
  #   sort=-time
  #
  #   layer=top
  #   anchor=top-right
  #
  #   font=Iosevka Nerd Font 12
  #   background-color=#1a1b26
  #   text-color=#c0caf5
  #   width=256
  #   height=500
  #   margin=10
  #   padding=5
  #   border-size=3
  #   border-color=#c0caf5
  #   border-radius=3
  #   progress-color=over #302D41
  #   icons=true
  #   max-icon-size=64
  #
  #   markup=true
  #   actions=true
  #   format=<b>%s</b>\n%b
  #   default-timeout=5000
  #   ignore-timeout=false
  #
  #
  #   text-alignment=center
  #   [urgency=high]
  #   border-color=#F8BD96
  # '';
  services.mako = {
    enable = true;
    font = "Iosevka Nerd Font 12";
    width = 256;
    height = 500;
    margin = "10";
    padding = "5";
    borderSize = 3;
    borderRadius = 3;
    backgroundColor = "#1a1b26";
    borderColor = "#c0caf5";
    progressColor = "over #302D41";
    textColor = "#c0caf5";
    defaultTimeout = 5000;
    extraConfig = ''
      text-alignment=center
      [urgency=high]
      border-color=#F8BD96
    '';
  };
}
