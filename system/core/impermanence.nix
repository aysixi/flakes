{ mi, ... }:
{
  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/etc/nixos" # bind mounted from /nix/persist/etc/nixos to /etc/nixos
        "/etc/NetworkManager/system-connections"
        "/var/log"
        "/var/lib"
        "/etc/secureboot"
        "/etc/daed"
        "/etc/dae-wing"
        "/etc/nginx"
      ];
      files = [
        # "/etc/machine-id"
        "/etc/create_ap.conf"
      ];
      users.${mi.userName} = {
        directories = [
          "真紅の魔法書"
          # "Blog"
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          ".cache"
          # "Codelearning"
          ".npm-global"
          ".config"
          ".thunderbird"
          "flakes"
          "Kvm"
          # "Projects"
          "rclone"
          "restic"
          # "win"
          ".cabal"
          ".cargo"
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
          ".local"
          ".mozilla"
          ".emacs.d"
          ".steam"
        ];
        files = [
          ".npmrc"
        ];
      };
    };
  };
}
