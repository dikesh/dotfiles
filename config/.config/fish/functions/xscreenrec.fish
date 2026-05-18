function xscreenrec
    if pkill wl-screenrec
        notify-send 'Screen Recorder' "Recording stopped .."
    else
        _start_recording
    end
end

function _start_recording
    # Param values
    set -l audio_device (pactl list short sources | rg RUNNING | cut -f2)
    if test -z "$audio_device"
        set audio_device default
    end

    set -l filename (string join '' "$HOME/Videos/" (date '+screenrec-%Y%m%d%H%M%S.mp4'))
    set -l output (niri msg -j focused-output | jq -r .name)

    # Start recording
    wl-screenrec --output $output --audio --audio-device $audio_device --filename $filename
end
