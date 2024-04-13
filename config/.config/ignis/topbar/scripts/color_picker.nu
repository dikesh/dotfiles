#!/usr/bin/env nu

# Select color
let output = (niri msg pick-color)

# If no color selected
if $output == "No color was picked." {exit}

# Extract hex color and copy to clipboard
let hex_color = ($output | rg 'Hex: (#\w+)' -or '$1')
$hex_color | wl-copy -n

# Send notification
(notify-send
  "Color Picker"
  $"\n<span color='($hex_color)'><i><b>($hex_color)</b></i></span> copied to clipboard")
