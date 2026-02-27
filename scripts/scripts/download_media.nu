#!/usr/bin/env nu

# Shell variables
$env.GUM_CONFIRM_SELECTED_BACKGROUND = "#008080"

# Constants
const EXT_M4A = "m4a"
const EXT_MP4 = "mp4"

# Get URL
let url = (gum input
    --header "URL:"
    --placeholder "https://www.instagram.com/reel/ABcD_Xyz/?igsh=Xyz_AbCE==")

# File Extension
let ext = (
  try {
    gum confirm --affirmative "Video" --negative "Audio" --default=true "Video / Audio"; $EXT_MP4
  } catch {
    |err| if $err.exit_code == 1 { $EXT_M4A }
  }
)

if $ext == $EXT_M4A {
  yt-dlp -x --audio-format $EXT_M4A --embed-thumbnail --no-playlist $url -o "%(title)s.%(ext)s"
} else {
  yt-dlp --merge-output-format $EXT_MP4 --embed-thumbnail --no-playlist $url -o "%(title)s.%(ext)s"
}
