{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    # shellWrapperName = "r"; #use functions
    plugins = {
      exifaudio = pkgs.fetchFromGitHub {
        owner = "sonico98";
        repo = "exifaudio.yazi";
        rev = "d7946141c87a23dcc6fb3b2730a287faf3154593";
        sha256 = "sha256-nXBxPG6PVi5vstvVMn8dtnelfCa329CTIOCdXruOxT4=";
      };
    };
    flavors = {
      kanagawa = pkgs.fetchFromGitHub {
        owner = "dangooddd";
        repo = "kanagawa.yazi";
        rev = "b32f205";
        sha256 = "sha256-hi3RXCle+KTHlhnQwKDJiHTOro0At9QJMwY2hwWU8Ic=";
      };
    };
  };

  home.file = {
    ".config/yazi/yazi.toml".source = ./yazi.toml;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/theme.toml".source = ./theme.toml;
  };

}
