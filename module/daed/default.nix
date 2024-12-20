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
  };
  sops.templates."config.dae".content = '' 
  	global {

      tproxy_port: 12345

      tproxy_port_protect: true

      pprof_port: 0

      so_mark_from_dae: 0

      log_level: info

      disable_waiting_network: false

      enable_local_tcp_fast_redirect: false

      lan_interface: enp7s0

      wan_interface: auto

      auto_config_kernel_parameter: true

      tcp_check_url: 'http://cp.cloudflare.com,1.1.1.1,2606:4700:4700::1111'

      tcp_check_http_method: HEAD

      udp_check_dns: 'dns.google:53,8.8.8.8,2001:4860:4860::8888'

      check_interval: 120s

      check_tolerance: 50ms

      dial_mode: domain++

      allow_insecure: false

      sniffing_timeout: 100ms

      tls_implementation: utls

      utls_imitate: chrome_auto

      mptcp: false

      # bandwidth_max_tx: '200 mbps'
      # bandwidth_max_rx: '1 gbps'
    }

      # Subscriptions defined here will be resolved as nodes and merged as a part of the global node pool.
      # Support to give the subscription a tag, and filter nodes from a given subscription in the group section.
      subscription {
          dau: '${config.sops.placeholder."dae/dau"}'
          ecy: '${config.sops.placeholder."dae/ecy"}'
       }

      # Nodes defined here will be merged as a part of the global node pool.
      node {

      }

      # See https://github.com/daeuniverse/dae/blob/main/docs/en/configuration/dns.md for full examples.
      dns {
        upstream {
          alidns: 'udp://223.5.5.5:53'
          googledns: 'tcp+udp://8.8.8.8:53'
        }
        routing {
          request {
          # qtype(aaaa) -> reject
          qname(geosite:category-ads-all) -> reject
          qname(geosite:openai) -> googledns
          qname(geosite:bilibili) -> alidns
          qname(geosite:cn) -> alidns
          fallback: googledns
          }
        }
      }

      # Node group (outbound).
      group {
        proxy {
          filter: subtag(ecy) 
          policy: min_avg10
        }
        jp {
          filter: subtag(ecy) && name(keyword: '日本')
          policy: min_avg10

        }
        tw {
          filter: subtag(ecy) && name(keyword: '台湾')
          policy: min_avg10

        }
        hk {
          filter: subtag(ecy) && name(keyword: '香港')
          policy: min_avg10

        }
        blockCN {
            filter: subtag(ecy) && !name(keyword: '香港')
            policy: min_avg10
        }
        r18 {
          filter: subtag(ecy) && name(keyword: '台湾')
          filter: subtag(ecy) && name(keyword: '土耳其')
          policy: min_avg10

        }
      }

      # See https://github.com/daeuniverse/dae/blob/main/docs/en/configuration/routing.md for full examples.
      routing {
      #hals

      # 9.16
      pname(NetworkManager, systemd-resolved) -> direct
      pname(xray) -> must_direct
      dscp(0x4) -> direct
      pname(qbittorrent) -> direct
      sport(3338) -> direct
      #dip(10.0.0.1) -> direct
      dip(224.0.0.0/3, 'ff00::/8') -> direct
      dip(geoip:private) -> direct
      l4proto(udp) && dport(443) -> block
      #ipversion(6) -> block
      dip(geoip:cn) -> direct
      domain(geosite:cn) -> direct

      #---------#
      # custom  #
      #---------#
      #pname(steam) -> direct
      #pname(telegram-desktop) -> direct
      pname(git) -> proxy
      

      domain(geosite:google) -> blockCN
      domain(geosite:openai) -> blockCN
      domain(regex:'.openai\.com$') -> blockCN
      domain(regex:'.chatgpt\.com$') -> blockCN
    

      dip(geoip:jp) -> jp
      dip(geoip:hk) -> hk 
      dip(geoip:tw) -> tw


      # SSH - tcp port 22 is blocked by many proxy servers.
      dport(22) && !dip(geoip:cn) && !domain(geosite:cn) -> proxy

      # Block ad
      domain(full:analytics.google.com) -> proxy  # do not block google analytics(console)
      domain(geosite:category-ads) -> block
      domain(geosite:category-ads-all) -> block

      # Steam
      #domain(suffix: steampowered.com) -> direct
      domain(geosite:category-games@cn) -> direct
      domain(suffix: steamserver.net) -> direct
      domain(geosite:steam@cn) -> direct 
      domain(star-engine.com) -> direct
      domain(geosite:steam) -> proxy
      
      #-------# 
      # proxy #
      #-------#
      domain(openwrt.org) -> proxy
      domain(exhentai.org, e-hentai.org) -> r18
      domain(suffix: 'pixiv.net') -> proxy
      domain(suffix: 'nixos.wiki') -> proxy
      domain(suffix: 'nixos-cn.org') -> proxy
      domain(suffix: 'nixos.org') -> proxy
  	domain(x.com) -> proxy

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
