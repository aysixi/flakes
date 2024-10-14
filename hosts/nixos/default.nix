{ pkgs, user, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  sops = {
    secrets.sshkey = {
      mode = "0600";
      owner = "${user}";
      path = "/home/" + "${user}" + "/.ssh/openwrt";
    };
    secrets.rclone = {
      mode = "0600";
      owner = "${user}";
      path = "/home/" + "${user}" + "/.config/rclone/rclone.con";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  #intel gpu
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
      intel-ocl
      intel-media-sdk
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
