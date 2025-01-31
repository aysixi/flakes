let
  directoryContents = builtins.readDir ./.;
  excludeDirs = [
    "waybar"
    "wsl"
    "gimp"
    "zathura"
    "youtube-tui"
    "prismlauncher"
  ];
  directories = builtins.filter (
    name: directoryContents."${name}" == "directory" && !(builtins.elem name excludeDirs)
  ) (builtins.attrNames directoryContents);
  imports = map (name: ./. + "/${name}") directories;
in
{
  imports = imports;
}
