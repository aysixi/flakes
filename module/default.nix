{ self, inputs, ... }:
let
  # system-agnostic args
  module_args._module.args = {
    inherit inputs self;
  };
in
{
  imports = [
    {
      _module.args = {
        # we need to pass this to HM
        inherit module_args;

        # NixOS modules
        sharedModules = [
          inputs.home-manager.nixosModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko

          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed

          # inputs.hyprland.nixosModules.default
          module_args
          ./core.nix
          ./nix.nix
          ./daed
        ];
        wslModules = [
          inputs.home-manager.nixosModule
          inputs.nixos-wsl.nixosModules.wsl
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          module_args
          ./core.nix
          ./nix.nix
        ];

      };
    }
  ];
}