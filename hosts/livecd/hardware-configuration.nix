# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports =
    [ ../../lib/disko/livecd.nix ]
    ++ [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # boot.initrd.luks.devices = {
  #   cryptroot.device = "/dev/sdb2";
  #   # luksroot = {
  #   #   device = "/dev/disk/by-uuid/06c208e0-dae1-4597-98b6-d25bdb609e96";
  #   #   allowDiscards = true;
  #   #   keyFileSize = 4096;
  #   #   # pinning to /dev/disk/by-id/usbkey works
  #   #   keyFile = "/dev/sdb";
  #   # };
  # };

  # fileSystems."/" = {
  #   device = "none";
  #   fsType = "tmpfs";
  #   options = [ "defaults" "size=25%" "mode=755" ];
  # };
  #
  # fileSystems."/nix" =
  #   {
  #     device = "/dev/mapper/pool-root";
  #     fsType = "btrfs";
  #     options = [ "subvol=nix" "compress=zstd" "noatime" ];
  #   };
  #
  # fileSystems."/boot" = {
  #   device = "/dev/sdb1";
  #   fsType = "vfat";
  # };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;
  #note
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
