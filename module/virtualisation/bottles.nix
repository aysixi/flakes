{ pkgs, config, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      bottles
    ];
  };
}