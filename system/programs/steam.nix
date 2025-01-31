{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    protontricks.enable = true; # Whether to enable protontricks, a simple wrapper for running Winetricks commands for Proton-enabled games.
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    package = pkgs.steam.override {
      extraPkgs = pkgs: [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-emoji
        pkgs.twemoji-color-font
      ];
      extraEnv = {
        # GTK_IM_MODULE = "xim";
        LC_ALL = "zh_SG.UTF-8";
      };
    };
  };
  environment.systemPackages = [
    # pkgs.protontricks
    # pkgs.r2modman
  ];
}
