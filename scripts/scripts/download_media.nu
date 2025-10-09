#!/usr/bin/env nu

# Get URL
let url = (gum input
    --header "URL:"
    --placeholder "https://www.instagram.com/reel/ABcD_Xyz/?igsh=Xyz_AbCE==")

# Filename without extension
let filename = (gum input --header "Ouput Filename:" --placeholder "running_dog")

let destpath = $"~/Downloads/($filename).mp4"
yt-dlp -t mp4 $url -o $destpath

print $"Downloaded to ($destpath) .."
