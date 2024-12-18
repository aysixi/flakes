{ inputs, withSystem, module_args, ... }:
let
  user = "mafuyu";
  domain = "aysixi.moe";

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
    "${user}@livecd" = [ ./livecd ] ++ sharedModules;
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;

in
{
  imports = [
    # we need to pass this to NixOS' HM module
    { _module.args = { inherit homeImports user domain; }; }
  ];


  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({ pkgs, ... }: {
      "${user}@nixos" = homeManagerConfiguration {
        modules = homeImports."${user}@nixos";
        inherit pkgs;
        # extraSpecialArgs = { inherit user; };
      };
      "${user}@wsl" = homeManagerConfiguration {
        modules = homeImports."${user}@wsl";
        inherit pkgs;
      };
      "${user}@livecd" = homeManagerConfiguration {
        modules = homeImports."${user}@livecd";
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
