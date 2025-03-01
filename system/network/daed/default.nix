{
  inputs,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with inputs.daeuniverse.packages.x86_64-linux; [
    dae-unstable
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
    "dae" = { };
  };
  sops.templates."config.dae".reloadUnits = [ "dae.service" ];
  sops.templates."config.dae".content = ''
    global {
      tproxy_port: 12345
      log_level: info

      tcp_check_http_method: HEAD
      tcp_check_url: 'http://cp.cloudflare.com,1.1.1.1,2606:4700:4700::1111'
      udp_check_dns: 'dns.google.com:53,8.8.8.8,2001:4860:4860::8888'
      check_interval: 20s
      check_tolerance: 100ms

      lan_interface: enp7s0
      wan_interface: auto

      allow_insecure: false
      auto_config_kernel_parameter: true
      check_interval: 300s
      dial_mode: domain++
      allow_insecure: false

      disable_waiting_network: false
      auto_config_kernel_parameter: true
      enable_local_tcp_fast_redirect: true
      sniffing_timeout: 100ms
      tls_implementation: utls
      utls_imitate: chrome_auto
      mptcp: false
      bandwidth_max_tx: '200 mbps'
      bandwidth_max_rx: '1 gbps'
    }

    ${config.sops.placeholder."dae"}
  '';
}
