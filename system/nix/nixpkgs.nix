{
  self,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
      self.overlays.default
      inputs.yazi.overlays.default
      inputs.rust-overlay.overlays.default

      inputs.nur.overlays.default

      (final: prev: {
        aysixi = inputs.aysixi.packages."${prev.system}";
      })

      (final: prev: {
        fcitx5-rime = prev.fcitx5-rime.override {
          rimeDataPkgs = with pkgs.aysixi; [
            rime-icea
          ];
        };
      })
    ];
  };
}
