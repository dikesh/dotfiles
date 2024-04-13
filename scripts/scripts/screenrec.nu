#!/usr/bin/env nu

def start-recording [] {
  let audio_device = pactl list short sources | rg RUNNING | cut -f2
  let filename = date now | format date $'($env.HOME)/Videos/screenrec-%Y%m%d%H%M%S.mp4'

  (wl-screenrec
    --output (niri msg -j outputs | from json | columns | sort | first)
    --audio
    --audio-device $audio_device
    --filename $filename)
}

try {
  pkill wl-screenrec
  notify-send 'Screen Recorder' "Recording stopped .."
} catch {
  start-recording
}
