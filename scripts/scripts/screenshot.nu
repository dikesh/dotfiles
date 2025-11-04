#!/usr/bin/env nu

def main [selection] {
  match $selection {
    "screen" => { grim -o (niri msg -j focused-output | from json | get name) - | satty -f - },
    "region" => { grim -g (slurp) - | satty -f - },
  }
}
