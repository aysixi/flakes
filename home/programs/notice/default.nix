{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      font = "iosevka nerd font 12";
      width = 256;
      height = 500;
      margin = "10";
      padding = "5";
      border-size = 3;
      border-radius = 3;
      background-color = "#1a1b26";
      border-color = "#c0caf5";
      progress-color = "over #302d41";
      text-color = "#c0caf5";
      default-timeout = 5000;
    };
    criteria = {
      "urgency=high" = {
        text-alignment = "center";
        border-color = "#f8bd96";
      };
    };
  };
}
