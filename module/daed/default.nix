{ inputs, config, ... }:
{
  imports = [
    # ./xray.nix
  ];
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
    "dae/ecy" = { };
    "dae/dau" = { };
    "dae/new" = { };
  };
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
    dau: '${config.sops.placeholder."dae/dau"}'
    ecy: '${config.sops.placeholder."dae/ecy"}'
    new: '${config.sops.placeholder."dae/new"}'
  }

  node { }

  dns {
    upstream {
      alidns: 'https://dns.alidns.com:443'
      googledns: 'https://dns.google.com:443'
    }
    routing {
      request {
      qtype(aaaa) -> reject
      qname(geosite:category-ads-all) -> reject
      qname(geosite:openai) -> googledns
      qname(geosite:bilibili) -> alidns
      qname(geosite:cn) -> alidns
      fallback: googledns
      }
    }
  }

  group {
    proxy {
      filter: subtag(new) 
      policy: min_avg10
    }
    jp {
      filter: subtag(new) && name(keyword: '日本')
      policy: min_avg10
    }
    tw {
      filter: subtag(new) && name(keyword: '台湾')
      policy: min_avg10
    }
    hk {
      filter: subtag(new) && name(keyword: '香港')
      policy: min_avg10
    }
    blockCN {
      filter: subtag(new) && !name(keyword: '香港')
      policy: min_avg10
    }
    r18 {
      filter: subtag(new) && name(keyword: '台湾')
      filter: subtag(new) && name(keyword: '土耳其')
      policy: min_avg10
    }
  }

# See https://github.com/daeuniverse/dae/blob/main/docs/en/configuration/routing.md for full examples.
  routing {
    #-----------#
    # must rule #
    #-----------#
    # Thu Jan  2 07:15:05 PM JST 2025     
    pname(NetworkManager, systemd-resolved) -> direct
    pname(xray) -> must_direct
    dport(53) -> must_rules
    # ↓↓↓ https://github.com/daeuniverse/dae/discussions/295
    dscp(0x4) -> direct
    sport(3338) -> direct
    dip(224.0.0.0/3, 'ff00::/8') -> direct
    dip(geoip:private) -> direct
    l4proto(udp) && dport(443) -> block
    ipversion(6) -> block
    dip(geoip:cn) -> direct
    domain(geosite:cn) -> direct

    #----------#
    # programs #
    #----------#

    # SSH - tcp port 22 is blocked by many proxy servers.
    dport(22) && !dip(geoip:cn) && !domain(geosite:cn) -> proxy
    
    # pname(steam) -> direct
    # pname(telegram-desktop) -> direct
    pname(qbittorrent) -> direct
    pname(git) -> proxy
    
    #----------#
    # Block ad #
    #----------#
    domain(full:analytics.google.com) -> proxy  # do not block google analytics(console)
    domain(geosite:category-ads) -> block
    domain(geosite:category-ads-all) -> block

    #------#
    # game #
    #------#
    #domain(suffix: steampowered.com) -> direct
    domain(geosite:category-games@cn) -> direct
    domain(suffix: steamserver.net) -> direct
    domain(geosite:steam@cn) -> direct 
    domain(star-engine.com) -> direct
    domain(konami.net) -> direct
    domain(geosite:steam) -> proxy

    #-------# 
    # proxy #
    #-------#
    domain(openwrt.org) -> proxy
    domain(suffix: 'pixiv.net') -> proxy
    domain(suffix: 'nixos.wiki') -> proxy
    domain(suffix: 'nixos-cn.org') -> proxy
    domain(suffix: 'nixos.org') -> proxy
    domain(x.com) -> proxy 

    domain(exhentai.org, e-hentai.org) -> r18

    domain(geosite:google) -> blockCN
    domain(geosite:openai) -> blockCN
    domain(regex:'.openai\.com$') -> blockCN
    domain(regex:'.chatgpt\.com$') -> blockCN

    dip(geoip:jp) -> jp
    dip(geoip:hk) -> hk 
    dip(geoip:tw) -> tw

    #--------#
    # direct # 
    #--------#
    domain(maj-soul.com) -> direct
    domain(regex: '\.bilibili\.com$') -> direct
    domain(163.com) -> direct
    domain(regex: '\.simpfun\.cn$') && dport(15691) -> direct

    #-----#
    # end #
    #-----#

    # Access all other foreign sites
    domain(geosite:geolocation-!cn) -> proxy
    !dip(geoip:cn) -> proxy
    fallback: direct
  }
  '';
}
