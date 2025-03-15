{
  # services.resolved.enable = true;
  networking = {
    # nameservers = [
    #   "8.8.8.8"
    #   "8.8.4.4"
    # ];
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
    };
    firewall = {
      allowedTCPPorts = [
        6600 # aria2
      ];
      allowedUDPPortRanges = [ ];
    };
    hosts = {
      "185.199.109.133" = [ "raw.githubusercontent.com" ];
      "185.199.111.133" = [ "raw.githubusercontent.com" ];
      "185.199.110.133" = [ "raw.githubusercontent.com" ];
      "185.199.108.133" = [ "raw.githubusercontent.com" ];
      "192.168.1.198" = [
        "firefox.com.cn"
        "download-ssl.firefox.com.cn"
        "firefoxchina.cn"
        "home.firefoxchina.cn"
        "start.firefoxchina.cn"
        "flash.cn"
        "directads.mcafee.com"
        "ads.mcafee.com"
      ];
    };
  };
}
