{ pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

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
      # intel-compute-runtime
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
  # hardware.opengl.enable = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
