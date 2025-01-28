{ lib, config, self, inputs, ... }:
{
  imports =
    [
      ../../wm/hyprland
      # ./wm/sway
      ../../wall
      ../../terminals
      ../../editors
      ../../shell
      ../../programs
    ];

  wayland.windowManager.hyprland = lib.mkIf config.wayland.windowManager.hyprland.enable { };
  nixpkgs = {
    # config = {
    #   allowBroken = true;
    #   allowUnsupportedSystem = true;
    #   allowUnfree = true;
    # };
    overlays = [
      self.overlays.default

      (final: prev: {
        aysixi = inputs.aysixi.packages."${prev.system}";
      })
    ];
  };

  # Autostart QEMU/KVM in the first initialization of NixOS
  # realted link: https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
