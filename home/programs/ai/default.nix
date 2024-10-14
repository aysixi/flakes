{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs;[
    chatgpt-cli
  ];
  #home.file.".config/chatgpt/config.json".text = import ./config.nix;
}
