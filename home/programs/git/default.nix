{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    git = {
      enable = true;
      # package = pkgs.emptyDirectory;
      # userName = "aysixi";
      # userEmail = "78737594+aysixi@users.noreply.github.com";
      signing = {
        key = "91E0341BB84A94A6";
        signByDefault = true;
      };
      settings = {
        user = {
          name = "aysixi";
          email = "78737594+aysixi@users.noreply.github.com";
        };
        url = {
          "ssh://git@github.com/aysixi" = {
            insteadOf = "https://github.com/aysixi";
          };
        };
        init = {
          defaultBranch = "main";
        };
        delta.features = "Catppuccin Mocha";
        diff.renames = false;
      };
    };
  };
}
