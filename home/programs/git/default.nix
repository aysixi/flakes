{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      # package = pkgs.emptyDirectory;
      userName = "aysixi";
      userEmail = "78737594+aysixi@users.noreply.github.com";
      signing = {
        key = "91E0341BB84A94A6";
        signByDefault = true;
      };
      extraConfig = {
        url = {
          "ssh://git@github.com/aysixi" = {
            insteadOf = "https://github.com/aysixi";
          };
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
