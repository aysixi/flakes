{ mi, ... }:
{
  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        ${mi.userName} ALL=(ALL) NOPASSWD:ALL
      '';
    };
    doas = {
      enable = true;
      extraConfig = ''
        permit nopass :wheel
      '';
    };
  };
}
