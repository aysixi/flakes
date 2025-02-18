{ pkgs, ... }:
''
  #!/usr/bin/env fish

  # Copyright (C) 2012-2014 Dmitry Medvinsky <me@dmedvinsky.name>. All Rights Reserved.
  # This file is licensed under the GPLv2+. Please see COPYING for more information.

  source ${pkgs.pass}/share/fish/vendor_completions.d/pass.fish

  function __fish_pass_needs_commands
      [ (count (commandline -opc)) -eq 2 ]
  end

  set -l PROG 'pass'

  function __fish_pass_get_prefix
      if set -q PASSWORD_STORE_DIR
          realpath -- "$PASSWORD_STORE_DIR"
      else
          echo "$HOME/.password-store"
      end
  end

  function __fish_pass_needs_command
      [ (count (commandline -opc)) -eq 1 ]
  end

  function __fish_pass_uses_command
      set -l cmd (commandline -opc)
      if [ (count $cmd) -gt 1 ]
          if [ $argv[1] = $cmd[2] ]
              return 0
          end
      end
      return 1
  end

  function __fish_pass_print_gpg_keys
      gpg2 --list-keys | grep uid | sed 's/.*<\(.*\)>/\1/'
  end

  function __fish_pass_print
      set -l ext $argv[1]
      set -l strip $argv[2]
      set -l prefix (__fish_pass_get_prefix)
      set -l matches $prefix/**$ext
      printf '%s\n' $matches | sed "s#$prefix/\(.*\)$strip#\1#"
  end

  function __fish_pass_print_entry_dirs
      __fish_pass_print "/"
  end

  function __fish_pass_print_entries
      __fish_pass_print ".gpg" ".gpg"
  end

  function __fish_pass_print_entries_and_dirs
      __fish_pass_print_entry_dirs
      __fish_pass_print_entries
  end

  function __fish_pass_git_complete
      set -l prefix (__fish_pass_get_prefix)
      set -l git_cmd (commandline -opc) (commandline -ct)
      set -e git_cmd[1 2] # Drop "pass git".
      complete -C"git -C $prefix $git_cmd"
  end


  complete -c $PROG -f -n '__fish_pass_uses_command otp' -a "(__fish_pass_print_entries)"

  complete -c $PROG -f -n '__fish_pass_needs_command' -a otp -d 'two file sa'

  complete -c $PROG -f -n '__fish_pass_uses_command otp' -s c -l clip -a "(__fish_pass_print_entries)" -d 'Generate an OTP code and optionally put it on the clipboard'

  complete -c $PROG -f -n '__fish_pass_needs_commands otp' -a 'insert' -d 'Prompt for and insert a new OTP key URI'
  complete -c $PROG -f -n '__fish_pass_uses_command otp insert' -s f -l force -s e -l echo -a "(__fish_pass_print_entries)"

  complete -c $PROG -f -n '__fish_pass_needs_commands otp' -a 'append' -d 'Appends an OTP key URI to an existing password file'
  complete -c $PROG -f -n '__fish_pass_uses_command otp append' -s f -l force -s e -l echo -a "(__fish_pass_print_entries)"

  complete -c $PROG -f -n '__fish_pass_needs_commands otp' -a 'uri' -d 'Display the key URI stored in pass-name'
  complete -c $PROG -f -n '__fish_pass_uses_command otp uri' -s c -l clip -s q -l qrcode -a "(__fish_pass_priant_entries)"

  complete -c $PROG -f -n '__fish_pass_needs_commands otp' -a validate -d "Test if the given URI is a valid OTP key URI"
''
