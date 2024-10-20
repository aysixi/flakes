{ ... }:
{
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };

  services.misskey = {
    enable = true;
    redis.createLocally = true;
    database.createLocally = true;
    settings = {
      url = "http://misskey.lan";
      port = 3000;
      db = {
        db = "misskey";
        user = "misskey";
        host = "/var/run/postgresql";
        # port = 5432;
        # pass = "misskey"; 
      };
    };
    reverseProxy = {
      enable = true;
      host = "misskey.lan";
      ssl = true;
      webserver.nginx = {
        enableACME = false;
        serverName = "misskey.lan";
        sslCertificate = "/etc/nginx/crt.pem";
        sslCertificateKey = "/etc/nginx/key.pem";
        onlySSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "[::1]";
            port = 443;
            ssl = true;
          }
          # {
          #   addr = "0.0.0.0";
          #   port = 80;
          # }
        ];
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:3000";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_redirect off;

              # If it's behind another reverse proxy or CDN, remove the following. 
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto https;

            
              # Cache settings
              proxy_cache cache1;
              proxy_cache_lock on;
              proxy_cache_use_stale updating;
              proxy_force_ranges on;
              add_header X-Cache $upstream_cache_status;

            '';
          };
        };
        extraConfig = ''
          ssl_session_timeout 1d;
          ssl_session_cache shared:ssl_session_cache:10m;
          ssl_session_tickets off;

          # SSL protocol settings
          ssl_protocols TLSv1.2 TLSv1.3;
          ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
          ssl_prefer_server_ciphers off;
          ssl_stapling on;
          ssl_stapling_verify on;

          ssl_dhparam /etc/nginx/dhparam.pem;   
  
        '';
      };


    };
  };

  services.nginx = {
    enable = true;
    clientMaxBodySize = "80m";
    proxyCachePath."cache1" = {
      enable = true;
      levels = "1:2";
      keysZoneName = "cache1";
      keysZoneSize = "16m";
      maxSize = "1g";
      inactive = "720m";
      useTempPath = false;
    };

    # virtualHosts."misskey.lan" = {
    #   enableACME = false;
    #   listen = [
    #     {
    #       addr = "0.0.0.0";
    #       port = 443;
    #       ssl = true;
    #     }
    #   ];
    #   # openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/key.pem -out /etc/nginx/crt.pem -days 365 -nodes
    #   # penssl dhparam -out /etc/nginx/dhparam.pem 2048
    #   sslCertificate = "/etc/nginx/crt.pem";
    #   sslCertificateKey = "/etc/nginx/key.pem";
    #   extraConfig = ''
    #     ssl_protocols TLSv1.2 TLSv1.3;
    #     ssl_prefer_server_ciphers on;
    #     ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384";
    #     ssl_session_cache shared:SSL:10m;
    #     ssl_session_timeout 5m;
    #     ssl_dhparam /etc/nginx/dhparam.pem;   
    #   '';
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:3000";
    #     proxyWebsockets = true;
    #     recommendedProxySettings = true;
    #     extraConfig = ''
    #       proxy_redirect off;
    #     '';
    #   };
    # };
    virtualHosts."xxx" = {
      serverName = "misskey.lan";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "[::1]";
          port = 80;
        }
      ];
      locations = {
        "/" = {
          return = "301 https://$host$request_uri";
        };
      };
    };
  };

  # services.postgresql = {
  #   enable = true;
  #   settings = {
  #     port = 5432;
  #   };
  #   ensureDatabases = [ "mydatabase" ];
  #   authentication = lib.mkOverride 10 ''
  #     #type database DBuser origin-address auth-method
  #     local all       all     trust
  #   '';
  # };
}
