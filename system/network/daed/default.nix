{
  inputs,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with inputs.daeuniverse.packages.x86_64-linux; [
    # dae
    daed
  ];

  services.dae = {
    enable = true;
    disableTxChecksumIpGeneric = false;
    package = inputs.daeuniverse.packages.x86_64-linux.dae-unstable;
    configFile = config.sops.templates."config.dae".path;
    assetsPath = toString (
      pkgs.symlinkJoin {
        name = "dae-assets-nixy";
        paths = [
          "${inputs.nixyDomains}/assets"
          "${pkgs.v2ray-geoip}/share/v2ray"
        ];
      }
    );
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  services.daed = {
    enable = false;
    listen = "0.0.0.0:25567";
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  sops.secrets = {
    "dae/pari/vless" = { };
    "dae/pari/tuic" = { };
    "dae/pari/hysteria2" = { };
    # "dae/ecy" = { };
    # "dae/dau" = { };
    "dae/new" = { };
    "dae/dns" = { };
    "dae/group" = { };
    "dae/routing" = { };
  };
  sops.templates."config.dae".reloadUnits = [ "dae.service" ];
  sops.templates."config.dae".content = ''
    global {
      tproxy_port: 12345
      log_level: info

      tcp_check_url: 'http://cp.cloudflare.com'
      udp_check_dns: 'dns.google.com:53,114.114.114.114:53,2001:4860:4860::8888,1.1.1.1:53'
      check_interval: 20s
      check_tolerance: 100ms

      lan_interface: enp7s0
      wan_interface: auto

      allow_insecure: false
      auto_config_kernel_parameter: true
      check_interval: 300s
      dial_mode: domain
      allow_insecure: false

      disable_waiting_network: false
      auto_config_kernel_parameter: true
      enable_local_tcp_fast_redirect: true
      sniffing_timeout: 100ms
      tls_implementation: utls
      utls_imitate: chrome_auto
      mptcp: true
    }

    subscription {
      new-file: '${config.sops.placeholder."dae/new"}'
    }

    node {
      vless: '${config.sops.placeholder."dae/pari/vless"}'
      tuic: '${config.sops.placeholder."dae/pari/tuic"}'
      hysteria2: '${config.sops.placeholder."dae/pari/hysteria2"}'
    }

    ${config.sops.placeholder."dae/dns"}

    ${config.sops.placeholder."dae/group"}

    ${config.sops.placeholder."dae/routing"}
  '';
}
