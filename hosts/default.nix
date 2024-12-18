{ inputs, user, domain, sharedModules, homeImports, wslModules, ... }:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
    in
    {
      nixos = nixosSystem {
        specialArgs = { inherit user domain; };
        modules = [
          ./nixos
          ../module/lanzaboote.nix
          # ../module/systemdboot.nix
          ../module/impermanence.nix
          ../module/desktop.nix
          ../module/fonts.nix
          # ../module/virtualisation
          ../module/steam.nix
          ../module/disk/default.nix
          ../module/misskey/default.nix
          ../module/sunshine/default.nix #need desktop

          {
            home-manager = {
              users.${user}.imports = homeImports."${user}@nixos";
              extraSpecialArgs = { inherit user; };
            };
          }
        ] ++ sharedModules;
      };

      minimal = nixosSystem {
        specialArgs = { inherit user; };
        modules =
          [
            ./minimal
            ../module/impermanence.nix
            ../module/systemdboot.nix
          ] ++ sharedModules;
      };

      wsl = nixosSystem {
        specialArgs = { inherit user; };
        modules =
          [
            ./wsl
            {
              home-manager = {
                extraSpecialArgs = { inherit user; };
                users.${user}.imports = homeImports."${user}@wsl";
              };
            }
          ] ++ wslModules;
      };

      livecd = nixosSystem {
        specialArgs = { inherit user; };
        modules =
          [
            ./livecd
            ../module/impermanence.nix
            ../module/systemdboot.nix
            {
              home-manager = {
                users.${user}.imports = homeImports."${user}@livecd";
                extraSpecialArgs = { inherit user; };
              };
            }
          ] ++ sharedModules;
      };
    };
}
