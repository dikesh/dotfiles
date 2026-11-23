#!/usr/bin/env sh
# Wrapper invoked by xdg-desktop-portal-termfilechooser.
# Extends the default yazi-wrapper.sh so selecting a directory during SaveFile
# saves the suggested filename into that directory instead of failing.

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"
debug="$6"

shift 6 # remaining positional args are TERMCMD

set -e

if [ "$debug" = 1 ]; then
    set -x
fi

cmd="yazi"

run_command() {
    if [ "$save" = "1" ]; then
        set -- "$@" "$cmd" --chooser-file="$out" "$path"
    elif [ "$directory" = "1" ]; then
        set -- "$@" "$cmd" --chooser-file="$out" --cwd-file="$out.1" "$path"
    else
        set -- "$@" "$cmd" --chooser-file="$out" "$path"
    fi

    "$@"
}
run_command "$@"

if [ "$save" = "1" ] && [ -s "$out" ]; then
    chosen="$(head -n 1 "$out")"
    if [ -d "$chosen" ]; then
        chosen="${chosen%/}"
        name="$(basename "$path")"
        dest="$chosen/$name"

        if [ "$dest" != "$path" ] && [ -e "$dest" ]; then
            case "$name" in
                ?*.*)
                    stem="${name%.*}"
                    ext=".${name##*.}"
                    ;;
                *)
                    stem="$name"
                    ext=""
                    ;;
            esac
            i=1
            while [ -e "$chosen/${stem}_${i}${ext}" ]; do
                i=$((i + 1))
            done
            dest="$chosen/${stem}_${i}${ext}"
        fi

        if [ -f "$path" ] && [ "$path" != "$dest" ]; then
            mv "$path" "$dest"
        elif [ ! -e "$dest" ]; then
            : > "$dest"
        fi
        printf '%s\n' "$dest" > "$out"
    fi
elif [ "$directory" = "1" ]; then
    if [ ! -s "$out" ] && [ -s "$out.1" ]; then
        cat "$out.1" > "$out"
    fi
    rm -f "$out.1"
fi
