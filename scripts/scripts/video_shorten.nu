#!/usr/bin/env nu

# Remove consecutive duplicate frames from video
let infile = (gum file --height 20 --file)
let outfile = (gum input --header "Output Filepath:")

(ffmpeg \
    -i $infile
    -vf "mpdecimate,setpts=N/FRAME_RATE/TB, scale=trunc(iw/2)*2:trunc(ih/2)*2"
    -fps_mode passthrough
    $outfile)
