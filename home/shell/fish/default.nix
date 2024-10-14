{ config, user, ... }:
{
  programs.fish = {
    enable = true;
    loginShellInit =
      if config.wayland.windowManager.hyprland.enable then ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
      ''
      else if config.wayland.windowManager.sway.enable then ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec sway
                	''
      else '''';
    interactiveShellInit = ''set fish_greeting ""'';
    shellAliases = {
      l = "ls -ahl";
      la = "exa -a --icons";
      ll = "exa -l --icons";
      ls = "exa";
      n = "neofetch";
      nf = ''nvim (FZF_DEFAULT_COMMAND='fd' FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'" fzf --height 60% --layout reverse --info inline --border --color 'border:#b48ead')'';
      # r = "yazi";
      top = "btop";
    };

    functions = {
      f = ''
        	FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git' FZF_DEFAULT_OPTS="--color=bg+:#000000,bg:#1E2031,spinner:#F3D398,hl:#F28FAD --color=fg:#C8D3F8,header:#F28FAD,info:#7AD9E5,pointer:#F3D398 --color=marker:#F3D398,fg+:#97DC8D,prompt:#7AD9E5,hl+:#F28FAD --preview 'bat --style=numbers --color=always --line-range :500 {}'" fzf --height 60% --layout reverse --info inline --border --color 'border:#b48ead'
      '';
    };
  };
  home.file = {
    ".config/fish/conf.d/mocha.fish".text = import ./mocha_theme.nix;
    ".config/fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
    ".config/fish/functions/xdg-get.fish".text = import ./functions/xdg-get.nix;
    ".config/fish/functions/xdg-set.fish".text = import ./functions/xdg-set.nix;
    ".config/fish/functions/owf.fish".text = import ./functions/owf.nix;
    ".config/fish/functions/r.fish".text = import ./functions/r.nix;
    ".config/fish/functions/kinak.fish".text = import ./functions/kinak.nix;
  };
}
