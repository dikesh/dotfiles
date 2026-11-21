#!/usr/bin/env fish

set -l dirpath "$HOME/apps/kitty-sessions/"
set -l ext '.kitty-session'
set -l theme_file "$HOME/.config/rofi/kitty-sessions.rasi"
set -l state_dir (set -q XDG_STATE_HOME; and echo "$XDG_STATE_HOME"; or echo "$HOME/.local/state")/kitty-sessions
set -l history_file "$state_dir/history.tsv"
set -l half_life 604800 # 7 days in seconds

set -l sessions (path basename -E $dirpath*$ext)
set -l total (count $sessions)
test $total -eq 0; and exit 0

set -l rows (
    printf '%s\n' $sessions | awk -F '\t' -v hist="$history_file" -v dir="$dirpath" -v ext="$ext" -v hl="$half_life" '
        function fmt_age(sec) {
            if (sec < 60) return "just now"
            if (sec < 3600) return int(sec / 60) "m ago"
            if (sec < 86400) return int(sec / 3600) "h ago"
            if (sec < 604800) return int(sec / 86400) "d ago"
            return int(sec / 604800) "w ago"
        }
        function esc(str) {
            gsub(/&/, "\\\\&amp;", str)
            gsub(/</, "\\\\&lt;", str)
            gsub(/>/, "\\\\&gt;", str)
            return str
        }
        function get_cd(path,    line, d) {
            d = ""
            while ((getline line < path) > 0) {
                if (line ~ /^cd[ \t]+/) {
                    sub(/^cd[ \t]+/, "", line)
                    sub(/[ \t]*\/?$/, "", line)
                    d = line
                    break
                }
            }
            close(path)
            return d
        }
        function get_icon(name) {
            if (name == "nvim") return ""
            if (name == "sessions") return "󰒓"
            if (name == "tasks") return "󰄬"
            if (name ~ /^mcp-/) return "󱁤"
            return "󰆍"
        }
        BEGIN {
            now = systime()
            while ((getline line < hist) > 0) {
                split(line, f, "\t")
                if (f[1] != "") {
                    score[f[1]] = f[2] + 0
                    ts[f[1]] = f[3] + 0
                }
            }
            close(hist)
        }
        {
            s = $0
            if (s in score) {
                age = now - ts[s]
                if (age < 0) age = 0
                val = score[s] * (0.5 ^ (age / hl))
                rel = fmt_age(age)
                icon_col = "#cba6f7"
                badge = "  <span size=\x27x-small\x27 foreground=\x27#89b4fa\x27>" rel "</span>"
            } else {
                val = 0
                rel = ""
                icon_col = "#6c7086"
                badge = ""
            }
            cd_path = get_cd(dir s ext)
            icon = get_icon(s)
            display = "<span foreground=\x27" icon_col "\x27>" icon "</span>  <b>" esc(s) "</b>" badge
            if (cd_path != "") {
                display = display "&#10;<span size=\x27small\x27 foreground=\x27#6c7086\x27>   " esc(cd_path) "</span>"
            }
            printf "%.6f\t%s\t%s\t%s\n", val, s, rel, display
        }
    ' | LC_ALL=C sort -t \t -k1,1gr -k2,2
)

set -l ranked
set -l display_rows
set -l top_name ""
set -l top_age ""
for row in $rows
    set -l parts (string split \t -- $row)
    set -a ranked $parts[2]
    set -a display_rows $parts[4]
    if test -z "$top_name"; and test -n "$parts[3]"
        set top_name $parts[2]
        set top_age $parts[3]
    end
end

set -l mesg_line1 "<span foreground='#cba6f7'><b>$total</b></span> <span foreground='#cdd6f4'>projects</span>"
set -l mesg_line2 "<span foreground='#6c7086'>Sorted by frecency</span>"
if test -n "$top_name"
    set mesg_line2 "<span foreground='#6c7086'>Top:</span> <span foreground='#89b4fa'><b>$top_name</b></span> <span foreground='#6c7086'>($top_age)</span>"
end
set -l mesg "$mesg_line1&#10;$mesg_line2"

set -l idx (
    printf '%s\n' $display_rows | rofi -dmenu \
        -no-custom \
        -markup-rows \
        -eh 2 \
        -format i \
        -mesg "$mesg" \
        -theme "$theme_file"
)
test -n "$idx"; or exit 0
set -l session $ranked[(math $idx + 1)]
test -n "$session"; and test -f "$dirpath$session$ext"; or exit 0

mkdir -p "$state_dir"
set -l tmp (mktemp "$state_dir/.history.XXXXXX")
awk -F '\t' -v OFS='\t' -v hist="$history_file" -v sel="$session" -v hl="$half_life" '
    BEGIN {
        now = systime()
        found = 0
        while ((getline line < hist) > 0) {
            split(line, f, "\t")
            if (f[1] == "") continue
            if (f[1] == sel) {
                age = now - (f[3] + 0)
                if (age < 0) age = 0
                new_score = (f[2] + 0) * (0.5 ^ (age / hl)) + 1.0
                printf "%s\t%.6f\t%d\n", sel, new_score, now
                found = 1
            } else {
                print line
            }
        }
        close(hist)
        if (!found) {
            printf "%s\t%.6f\t%d\n", sel, 1.0, now
        }
    }
' > "$tmp"
mv -f "$tmp" "$history_file"

exec kitty --session "$dirpath$session$ext"
