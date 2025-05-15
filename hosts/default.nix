{ inputs, self, ... }:
{
  flake.nixosConfigurations =
    let
      mi = import ../mi.nix;
    in
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      homeImports = import "${self}/home/profiles";
      mod = "${self}/system";
      specialArgs = {
        inherit inputs self mi;
      };
    in
    {
      nixos = nixosSystem {
        specialArgs = specialArgs // {
          enableLanzaboote = true;
        };
        modules = [
          ./nixos
          "${mod}/nix"
          "${mod}/core/boot.nix"
          # "${mod}/core/lanzaboote.nix"
          # "${mod}/core/systemdboot.nix"
          "${mod}/core/impermanence.nix"
          "${mod}/core"
          "${mod}/core/network.nix"
          "${mod}/core/sops.nix"
          "${mod}/network/daed"
          "${mod}/programs/fonts.nix"
          "${mod}/programs/desktop.nix"
          "${mod}/programs/steam.nix"
          "${mod}/programs/misskey"
          "${mod}/programs/sunshine"
          "${mod}/programs/disk"
          "${mod}/virtualisation"
          # "${mod}/hardware"
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager

          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
          # inputs.stylix.nixosModules.stylix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${mi.userName}.imports = homeImports."${mi.userName}@nixos" or [ ];
            };
          }
        ];
      };
      minimal = nixosSystem {
        specialArgs = specialArgs // {
          enableLanzaboote = false;
        };
        modules = [
          ./minimal
          "${mod}/nix"
          # "${mod}/core/lanzaboote.nix"
          "${mod}/core/systemdboot.nix"
          "${mod}/core/impermanence.nix"
          "${mod}/core"
          "${mod}/core/network.nix"
          "${mod}/network/daed"
          inputs.impermanence.nixosModules.impermanence
          inputs.disko.nixosModules.disko

          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed
        ];
      };

      wsl = nixosSystem {
        specialArgs = specialArgs // {
          enableLanzaboote = false;
        };
        modules = [
          ./wsl
          "${mod}/nix"
          "${mod}/core"
          "${mod}/core/sops.nix"
          "${mod}/core/network.nix"
          inputs.home-manager.nixosModule
          inputs.nixos-wsl.nixosModules.wsl
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${mi.userName}.imports = homeImports."${mi.userName}@wsl" or [ ];
            };
          }
        ];
      };

      livecd = nixosSystem {
        specialArgs = specialArgs // {
          enableLanzaboote = false;
        };
        modules = [
          ./livecd
          "${mod}/nix"
          # "${mod}/core/lanzaboote.nix"
          "${mod}/core/systemdboot.nix"
          "${mod}/core/impermanence.nix"
          "${mod}/core"
          "${mod}/core/sops.nix"
          "${mod}/core/network.nix"
          "${mod}/network/daed"
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${mi.userName}.imports = homeImports."${mi.userName}@livecd" or [ ];
            };
          }
        ];
      };
    };
}
