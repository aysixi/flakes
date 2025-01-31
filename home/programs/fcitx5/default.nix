{ config, pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons =
      with pkgs;
      [
        fcitx5-chinese-addons
        fcitx5-anthy
        fcitx5-table-extra
        fcitx5-rime
      ]
      ++ (with pkgs.aysixi; [
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ]);
  };
  home.file = {
    ".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
    ".local/share/fcitx5/themes/Catppuccin/theme.conf".text = import ./theme.nix;
  };
}
