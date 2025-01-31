{
  inputs,
  self,
  withSystem,
  ...
}:
let
  mi = import ../../mi.nix;
in
let
  sharedModules = [
    ../.
  ];
  homeImports = {
    "${mi.userName}@nixos" = [ ./nixos ] ++ sharedModules;
    "${mi.userName}@wsl" = [ ./wsl ] ++ sharedModules;
    "${mi.userName}@lilivecd" = [ ./wsl ] ++ sharedModules;
  };

  specialArgs = {
    inherit inputs self mi;
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in
{
  flake = {
    homeConfigurations = withSystem "x86_64-linux" (
      { pkgs, ... }:
      {
        "${mi.userName}@nixos" = homeManagerConfiguration {
          modules = homeImports."${mi.userName}@nixos";
          extraSpecialArgs = specialArgs;
          inherit pkgs;
        };
        "${mi.userName}@wsl" = homeManagerConfiguration {
          modules = homeImports."${mi.userName}@wsl";
          extraSpecialArgs = specialArgs;
          inherit pkgs;
        };
        "${mi.userName}@lilivecd" = homeManagerConfiguration {
          modules = homeImports."${mi.userName}@lilivecd";
          extraSpecialArgs = specialArgs;
          inherit pkgs;
        };
      }
    );
  };
}
