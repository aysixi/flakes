# ./foo.nix
{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.services.aria2;
in
{
  options.services.aria2 = {
    enable = mkEnableOption "the aria2 program";

    package = mkOption {
      type = types.package;
      default = pkgs.aria2;
      defaultText = literalExpression "pkgs.aria2";
      description = "aria2 package to use.";
    };

    extraConfig = mkOption {
      default = "";
      example = ''
        xxxx
      '';
      type = types.path;
      description = ''
        config for aria2.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    systemd.user.services = {
      aria2 = {
        Unit = {
          Description = "aria2 deamon";
          After = "default.target";
          Requires = "default.target";
          PartOf = "default.target";
        };
        Install.WantedBy = [ "default.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.aria2}/bin/aria2c --conf-path /home/${config.home.username}/.config/aria2/aria2.conf";
        };
      };
    };
  };
}