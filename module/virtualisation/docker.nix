{ pkgs, user, ... }:
let
  ServerIP = "serverIP";
in
{
  virtualisation = {
    docker.enable = true;
    docker.storageDriver = "btrfs";
  };

  users.groups.docker.members = [ "${user}" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
