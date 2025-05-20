{
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://gomibox.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "gomibox.cachix.org-1:M3V3Xzc+tMCxAMf4GzGkhGebm00Lk3vLEgU7f97JL/8="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
