{ inputs, withSystem, module_args, ... }:
let
  user = "kotori";

  sharedModules = [
    (import ../. { inherit user; })
    module_args
    # inputs.hyprland.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
    inputs.nur.hmModules.nur
  ];

  homeImports = {
    "${user}@nixos" = [ ./nixos ] ++ sharedModules;
    "${user}@wsl" = [ ./wsl ] ++ sharedModules;
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;

in
{
  imports = [
    # we need to pass this to NixOS' HM module
    { _module.args = { inherit homeImports user; }; }
  ];


  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({ pkgs, ... }: {
      "${user}@nixos" = homeManagerConfiguration {
        modules = homeImports."${user}@nixos";
        inherit pkgs;
      };
      "${user}@wsl" = homeManagerConfiguration {
        modules = homeImports."${user}@wsl";
        inherit pkgs;
      };
    });
  };

  # flake =
  #   {
  #     homeConfigurations."${user}@nixos" = homeManagerConfiguration {
  #       pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  #       modules = [
  #         inputs.hyprland.homeManagerModules.default
  #         inputs.nur.hmModules.nur
  #       ];
  #     };
  #   };

}
