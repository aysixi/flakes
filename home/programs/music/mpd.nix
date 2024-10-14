'' 
music_directory    "~/Music"
pid_file           "~/.config/mpd/pid"
state_file         "~/.config/mpd/state"
sticker_file       "~/.config/mpd/sticker.sql"
auto_update	"yes"


# input {
        # plugin "curl"
# }
audio_output {
#        host            "localhost"
#        port            "6600"
        type            "pulse"
        name            "pulse audio"
}

#bind_to_address "/run/user/1000/mpd/socket"
#bind_to_address "@mpd"
bind_to_address "[::1]:6600"
#bind_to_address "0.0.0.0:10002"
''
