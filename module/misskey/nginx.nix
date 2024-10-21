{ config, lib, user, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "localhost" = {
        listen = [{ addr = "0.0.0.0"; port = 80; }];
        root = ./webpage;
        extraConfig = ''
          index index.html; 
        '';
      };
    };
  };
}
