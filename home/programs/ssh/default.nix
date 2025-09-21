{
  mi,
  ...
}:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host nixos
        Hostname ${mi.domain}
        Port 25566
        User ${mi.userName}
        IdentitiesOnly yes
        IdentityFile ~/.ssh/nixos
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
        IdentitiesOnly yes
        IdentityFile ~/.ssh/github
      Host android
        Hostname 10.0.0.220
        Port 25566
        IdentitiesOnly yes
        IdentityFile ~/.ssh/android
      Host openwrt
        Hostname 10.0.0.1
        Port 22
        User root
        IdentitiesOnly yes
        IdentityFile ~/.ssh/openwrt
      Host vps.r
        Hostname nadeko.top
        Port 22122
        User root
        IdentitiesOnly yes
        IdentityFile ~/.ssh/vps
      Host vps.n
        Hostname nadeko.top
        Port 22122
        User nadeko
        IdentitiesOnly yes
        IdentityFile ~/.ssh/vps
    '';
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
  services.ssh-agent.enable = true;
}
