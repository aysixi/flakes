let
  directoryContents = builtins.readDir ./.;
  excludeDirs = [
    "dbclient"
    "gimp"
    "neofetch"
    "noctalia-shell"
    "prismlauncher"
    "waybar"
    "wsl"
    "youtube-tui"
    "zathura"
  ];
  directories = builtins.filter (
    name: directoryContents."${name}" == "directory" && !(builtins.elem name excludeDirs)
  ) (builtins.attrNames directoryContents);
  imports = map (name: ./. + "/${name}") directories;
in
{
  imports = imports;
}
