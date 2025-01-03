{ user, ... }:
''
  function kinak
    set -lx misskey_path '/home/${user}/rclone/misskey'
    pg_dump -U misskey -h localhost -p 5432 -d misskey -F c -f ~/rclone/misskey/misskey.dump
    sudo cp -r /var/lib/redis-misskey/dump.rdb $misskey_path/dump.rdb
    sudo chown ${user} $misskey_path/dump.rdb
    sudo cp -r /var/lib/private/misskey/ $misskey_path/ #storage
    sudo chown -R ${user} $misskey_path/misskey         #storage
    tar -czvf ~/misskey_all.tar.gz $misskey_path
    age -p -o ~/misskey_all.tar.gz.age ~/misskey_all.tar.gz
    rm -r ~/rclone/misskey/*
    cp ~/misskey_all.tar.gz.age $misskey_path
  end

  function kinak_menu

      read -s -P "Enter rclone password: " RCLONE_CONFIG_PASS
      echo
      read -s -P "Enter restic password: " RESTIC_PASSWORD
      echo
      set -lx RCLONE_CONFIG_PASS $RCLONE_CONFIG_PASS
      set -lx RESTIC_PASSWORD $RESTIC_PASSWORD

      while true
          echo -e "1 to backup"
          echo -e "2 to gc"
          echo -e "3 to push"
          echo -e "4 to print snapshots"
          echo -e "5 to check repository"
          echo -e "6 to forge <hashid>"
          echo -e "7 to mount ~/mnt"
          echo -e "8 to pull remote"
          echo -e "9 to custom command"
          echo -e "0 to exit"
        
          read -P "ready?: " answer
          switch $answer
              case "1"
                  echo -e "Start backup🌟\n"
                  restic -r rclone:restic-local: backup --tag flakes❄️  ~/flakes
                  echo -e "flakes 🌟\n"
                  restic -r rclone:restic-local: backup --tag Pictures🎨 ~/Pictures
                  echo -e "Pictures 🌟\n"
                  restic -r rclone:restic-local: backup --tag Music🎵 ~/Music/bgm/
                  echo -e "Music 🌟\n"
                  restic -r rclone:restic-local: backup --tag Video📼 ~/Videos/
                  echo -e "Video 🌟\n"
                  restic -r rclone:restic-local: backup --tag Documents📚 ~/Documents/
                  echo -e "Documents 🌟\n"
                  restic -r rclone:restic-local: backup --tag rclone🌌 ~/rclone/
                  echo -e "rclone 🌟\n" 
                  restic -r rclone:restic-local: backup --tag 真紅の魔法書📖 ~/真紅の魔法書/
                  echo -e "真紅の魔法書 🌟\n"
              case "2"
                  echo -e "Start gc"
                  restic -r rclone:restic-local: forget --keep-last 1 --prune 
              case "3"
                  echo -e "Start push"
                  rclone sync ~/restic google:restic -P #restic

                  rclone sync ~/rclone/secrets🔑 google:/rclone/secrets🔑 -P #secrets all

                  tar -czvf ~/password-store.tar.gz ~/.local/share/password-store/ #password-store 
                  age -p -o ~/password-store.tar.gz.age ~/password-store.tar.gz 
                  echo -e "test unlock🔓"
                  age -d ~/password-store.tar.gz.age > /dev/null
                  if test $status -eq 0
                  rclone copy ~/password-store.tar.gz.age google:/rclone/ -P
                  echo -e "all in🌟\n"
                  else
                    echo "error"
                  end

              case "4"
                  echo -e "Print snapshots"
                  restic -r rclone:restic-local: snapshots
                  restic -r rclone:restic-google: snapshots
              case "5"
                  echo -e "Check restic repository"
                  rclone check ~/restic/ google:restic/
              case "6"
                  read -P "Hash id: " hashId
                  set hashIdM (string trim -c '"' "$hashId")
                  eval restic -r rclone:restic-local: forget $hashIdM --keep-last 1 --prune
              case "7"
                  echo -e "start mnt \n"
                  mkdir ~/mnt
                  restic -r rclone:restic-local: mount ~/mnt
              case "8"
                  echo -e "start pull \n"
                  rclone sync google:restic ~/restic -P
              case "9"
                  read -P "Custom command: " whatCommand
                  eval $whatCommand
              case "0"
                  echo -e "exit"
                  return
          end
      end
  end

''
