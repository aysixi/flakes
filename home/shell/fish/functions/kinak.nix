{ mi, ... }:
''
  function backup_restic
    set -l tag $argv[1]
    set -l path $argv[2]
    echo "Start : $tag"
    restic -r rclone:restic-local: backup --tag $tag $path

    if test $status -ne 0
      echo "❌ 错误: 检查输出"
      return 1
    end
  end


  function kinakm
    set -lx FILE "$(date "+%Y-%m-%d"T"%H:%M:%S")"
    set -lx misskey_path '/home/mafuyu/rclone/misskey'

    # 数据库备份
    pg_dump -U misskey -h /var/run/postgresql -p 5432 -d misskey -F c -f ~/rclone/misskey/postgresql-$FILE.dump

    # 其他的必要数据
    sudo cp -r /var/lib/redis-misskey/ $misskey_path/redis-$FILE.rdb
    sudo cp -r /var/lib/private/ $misskey_path/misskey-$FILE
    sudo chown -R mafuyu $misskey_path
    # tar -czvf ~/misskey_all.tar.gz $misskey_path
  end


  function kinak
    trap 'exit' SIGINT

    read -s -P "Enter rclone password: " RCLONE_CONFIG_PASS
    echo
    read -s -P "Enter restic password: " RESTIC_PASSWORD
    echo
    set -lx RCLONE_CONFIG_PASS $RCLONE_CONFIG_PASS
    set -lx RESTIC_PASSWORD $RESTIC_PASSWORD

    # 本地restic 锚点
    set -lx restic_local "restic -r rclone:restic-local:"
    # google restic 锚点
    set -lx restic_google "restic -r rclone:restic-google:"

    while true
      printf "======= 选择操作 =======\n\n"
      printf "1. 备份all\n"
      printf "2. 清理 restic过期数据\n"
      printf "3. copy到google云\n"
      printf "4. 打印快照\n"
      printf "5. 检查存储库直接差异\n"
      printf "6. 删除快照 需要hash id\n"
      printf "7. 挂载本地存储库到 ~/mnt\n"
      printf "8. 同步远端数据到本地\n"
      printf "9. 自定义命令\n"
      printf "任意键退出\n\n"

      read -P "选择操作: " answer
      switch $answer
        case "1"
          backup_restic flakes❄️  ~/flakes
          backup_restic Pictures🎨 ~/Pictures
          backup_restic Music🎵 ~/Music/bgm/
          backup_restic Video📼 ~/Videos/
          backup_restic Documents📚 ~/Documents/
          backup_restic rclone🌌 ~/rclone
          backup_restic nikki🍰 ~/nikki
          backup_restic Projects ~/Projects

        case "2"
          eval $restic_local forget --keep-last 1 --prune
          echo -e "清理 restic过期数据\n"

        case "3"
          # restic copy
          echo -e "开始备份到Google云\n"
          rclone sync ~/restic google:restic -P
          rclone sync ~/rclone/secrets🔑 google:/rclone/secrets🔑 -P

          tar -czvf ~/password.tar.gz ~/rclone/password/
          age -p -o ~/password.tar.gz.age ~/password.tar.gz > /dev/null 2>&1

          echo -e "检查是否正常解密"
          age -d ~/password-store.tar.gz.age > /dev/null 2>&1
          if test $status -eq 0
            rclone copy ~/password.tar.gz.age google:/rclone/ -P
          else
            echo "不能正确解密"
          end

          echo -e "copy到google云\n"

        case "4"
          eval $restic_local snapshots
          eval $restic_google snapshots
          echo -e "打印快照\n"

        case "5"
          rclone check ~/restic/ google:restic/
          echo -e "检查存储库直接差异\n"

        case "6"
          read -P "Hash id: " hashId
          set hashIdM (string trim -c '"' "$hashId")
          eval eval $restic_local forget $hashIdM --keep-last 1 --prune
          echo -e "删除快照 需要hash id\n"

        case "7"
          mkdir ~/mnt
          eval $restic_local mount ~/mnt
          echo -e "挂载本地存储库到 ~/mnt\n"

        case "8"
          rclone sync google:restic ~/restic -P
          echo -e "同步远端数据到本地\n"

        case "9"
          read -P "自定义命令\n" whatCommand
          eval $whatCommand

        case '*'
          return
      end
    end
  end

''
