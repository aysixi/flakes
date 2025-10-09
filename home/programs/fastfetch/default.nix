{
  pkgs,
  mi,
  ...
}:

{
  home.packages = with pkgs; [
    fastfetch
  ];
  home.file.".config/fastfetch/config.jsonc".text = import ./config.nix { inherit mi; };
}
