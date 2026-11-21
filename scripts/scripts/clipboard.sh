#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--wipe" ]]; then
  read -r -n 1 -p "Clear all clipboard history? [y/N] " ans || true
  echo
  if [[ "${ans:-}" == [yY] ]]; then
    cliphist wipe
    wl-copy --clear
  fi
  exit 0
fi

if [[ "${1:-}" == "--pick" ]]; then
  out_file="$2"
  self="$(printf '%q' "$0")"
  selection="$(
    SHELL=/bin/sh cliphist list | SHELL=/bin/sh fzf \
      --style=full \
      --layout=reverse \
      --no-sort \
      --delimiter=$'\t' \
      --with-nth=2.. \
      --prompt='Clipboard > ' \
      --footer='Enter: copy  |  Alt-d: delete  |  Alt-Shift-d: clear all  |  Esc: cancel' \
      --preview='case {} in *"[[ binary data "*) printf "%s\n" {} | cut -f2- ;; *) printf "%s\n" {} | cliphist decode ;; esac' \
      --preview-window='down:45%:wrap' \
      --bind='tab:down,shift-tab:up' \
      --bind='alt-d:execute-silent(printf "%s\n" {} | cliphist delete)+reload(cliphist list)' \
      --bind="alt-D:execute($self --wipe)+reload(cliphist list)"
  )" || exit 0

  [[ -n "$selection" ]] && printf '%s\n' "$selection" > "$out_file"
  exit 0
fi

# Toggle off if already open
if pkill -f '^foot -a cliphist-picker '; then
  exit 0
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

foot -a cliphist-picker \
  -T Clipboard \
  -f "JetBrainsMono Nerd Font Mono:size=12" \
  -o main.pad=12x12 \
  -o colors-dark.alpha=0.9 \
  -o colors-dark.background=1e1e2e \
  -o colors-dark.foreground=cdd6f4 \
  "$0" --pick "$tmp" || true

if [[ -s "$tmp" ]]; then
  cliphist decode < "$tmp" | wl-copy
fi
