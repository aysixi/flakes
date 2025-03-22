{
  config,
  pkgs,
  mi,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      pnpm_9
      nodejs_20
    ];
  };
  sops.secrets = {
    # "misskey/database" = { mode = "0744"; };
    "misskey/redis" = {
      mode = "0744";
    };
    "misskey/meilisearch" = {
      mode = "0744";
    };
    "misskey/meilisearch.key" = {
      mode = "0744";
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
        20000
      ];
    };
    hosts = {
      "127.0.0.3" = [ "${mi.domain}" ];
      "::1" = [ "${mi.domain}" ];
    };
  };

  services.postgresql = {
    identMap = ''
      # ArbitraryMapName systemUser DBUser
       superuser_map      root      postgres
       superuser_map      postgres  postgres
       # Let other names login as themselves
       superuser_map      /^(.*)$   \1
       superuser_map      ${mi.userName}      misskey
    '';
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method optional_ident_map
      local    all    postgres    peer
      local    all    misskey     peer    map=superuser_map
    '';
    extensions = with pkgs; [
      postgresql15JitPackages.pgroonga
    ];
  };

  services.postgresqlBackup = {
    enable = true;
    pgdumpOptions = "-F c";
    startAt = "*-*-* 13:00:00";
    location = "/var/backup/postgresql";
    databases = [
      "misskey"
    ];
  };

  services.redis.servers.misskey.requirePassFile = config.sops.secrets."misskey/redis".path;
  services.meilisearch.masterKeyEnvironmentFile = config.sops.secrets."misskey/meilisearch".path;
  # services.meilisearch.package = pkgs.aysixi.meilisearch;

  services.misskey = {
    enable = true;
    package = pkgs.paricofe;
    redis.createLocally = true;
    redis.passwordFile = config.sops.secrets."misskey/redis".path;
    database.createLocally = true;
    # database.passwordFile = config.sops.secrets."misskey/database".path;
    meilisearch.createLocally = true;
    meilisearch.keyFile = config.sops.secrets."misskey/meilisearch.key".path;
    settings = {
      url = "http://${mi.domain}";
      # port = 3000;
      redis = {
        port = 6379;
        host = "localhost";
        # pass = config.sops.secrets."misskey/redis".path;
      };
      db = {
        db = "misskey";
        user = "misskey";
        port = 5432;
        host = "/var/run/postgresql";
        # pass = config.sops.secrets."misskey/database".path;
      };
      meilisearch = {
        # ssl = true;
        port = 7700;
        host = "localhost";
        # apiKey = config.sops.secrets."misskey/meilisearch.key".path;
      };
    };
    reverseProxy = {
      enable = true;
      host = "${mi.domain}"; # services.misskey.settings.url
      ssl = true;
      webserver.nginx = {
        enableACME = false;
        # serverName = ""; # bind reverseProxy.host
        sslCertificate = "/etc/nginx/crt.pem";
        sslCertificateKey = "/etc/nginx/key.pem";
        # openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/key.pem -out /etc/nginx/crt.pem -days 365 -nodes
        onlySSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 443;
            ssl = true;
          }
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

          # openssl dhparam -out /etc/nginx/dhparam.pem 2048
          ssl_dhparam /etc/nginx/dhparam.pem;
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
          proxy_headers_hash_max_size 1024;
          proxy_headers_hash_bucket_size 128;
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
    virtualHosts."xxx" = {
      serverName = "${mi.domain}"; # bind services.misskey.settings.url
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "[::]";
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
}
