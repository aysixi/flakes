''
  function kinak
      read -s -P "Enter rclone password: " RCLONE_CONFIG_PASS
      echo
      read -s -P "Enter restic password: " RESTIC_PASSWORD
      echo
      set -lx RCLONE_CONFIG_PASS $RCLONE_CONFIG_PASS
      set -lx RESTIC_PASSWORD $RESTIC_PASSWORD

      while true
  		echo -e "1 to backup"
      	echo -e "2 to gc"
  		echo -e "3 to sync"
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
  				echo -e "flakes OK🌟\n"
                  restic -r rclone:restic-local: backup --tag Pictures🎨 ~/Pictures
                  echo -e "Pictures OK🌟\n"
                  restic -r rclone:restic-local: backup --tag Music🎵 ~/Music/bgm/
                  echo -e "Music OK🌟\n"
  				restic -r rclone:restic-local: backup --tag Video📼 ~/Videos/
  				echo -e "Video OK🌟\n"
                  restic -r rclone:restic-local: backup --tag Documents📚 ~/Documents/
                  echo -e "Documents OK🌟\n"
                  restic -r rclone:restic-local: backup --tag rclone🌌 ~/rclone/
                  echo -e "rclone OK🌟\n" 
                  restic -r rclone:restic-local: backup --tag 真紅の魔法書📖 ~/真紅の魔法書/
                  echo -e "真紅の魔法書 OK🌟\n"
              case "2"
                  echo -e "Start gc"
                  restic -r rclone:restic-local: forget --keep-last 1 --prune 
              case "3"
                  echo -e "Start sync"
                  rclone sync ~/restic google:restic -P
                  rclone sync ~/rclone/secrets🔑 google:/rclone/secrets🔑 -P
                  rclone sync ~/rclone/decrypt🔒 google:/rclone/decrypt🔒 -P
                  tar -czvf ~/password-store.tar.gz ~/.local/share/password-store/
                  age -p -o ~/password-store.tar.gz.age ~/password-store.tar.gz 
                  rclone copy ~/password-store.tar.gz.age google:/rclone/ -P
                  echo -e "all in🌟\n"

              case "4"
                  echo -e "Print snapshots"
                  restic -r rclone:restic-local: snapshots
                  restic -r rclone:restic-google: snapshots
              case "5"
                  echo -e "Check repository"
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
  				rclone sync google:restic ~/restic 
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
