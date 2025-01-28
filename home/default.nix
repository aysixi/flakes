{ inputs
, self
, config
, mi
, ...
}:
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    inputs.nur.modules.homeManager.default
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

  home.stateVersion = "23.11";
}
