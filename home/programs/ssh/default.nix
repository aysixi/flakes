{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
        IdentityFile ~/.ssh/github
      Host openwrt
        Hostname 192.168.168.1
        Port 22
        User root
        IdentityFile ~/.ssh/openwrt
      Host vps.r
        Hostname nadeko.top
        Port 22122
        User root
        IdentityFile ~/.ssh/vps
      Host vps.n
        Hostname nadeko.top
        Port 22122
        User nadeko
        IdentityFile ~/.ssh/vps
    '';
  };
  services.ssh-agent.enable = true;
}
