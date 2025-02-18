{ inputs, config, ... }:
{
  environment.systemPackages = with inputs.daeuniverse.packages.x86_64-linux; [
    dae
    daed
  ];

  services.dae = {
    enable = true;
    package = inputs.daeuniverse.packages.x86_64-linux.dae;
    configFile = config.sops.templates."config.dae".path;
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
      log_level: info

      lan_interface: enp7s0
      wan_interface: auto

      allow_insecure: false
      auto_config_kernel_parameter: true
      check_interval: 300s
      dial_mode: domain++

      tls_implementation: utls
      utls_imitate: chrome_auto
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
