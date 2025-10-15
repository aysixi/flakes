{
  inputs,
  self,
  config,
  mi,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  home = {
    username = "${mi.userName}";
    homeDirectory = "/home/${mi.userName}";
    language.base = "en_US.UTF-8";
    sessionVariables = {
      NIX_AUTO_RUN = "1";
    };
  };
  programs = {
    home-manager.enable = true;
  };

  home.stateVersion = "25.05";
}
