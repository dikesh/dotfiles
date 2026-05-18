function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert

    # Change directory
    bind --mode default \e\cf _fzf_cd_with_query
    bind --mode insert \e\cf _fzf_cd_with_query

    # History search
    bind --mode default \cr _fzf_history_search
    bind --mode insert \cr _fzf_history_search

    bind --mode default \e\cr _fzf_history_search_sorted
    bind --mode insert \e\cr _fzf_history_search_sorted

    bind --mode default \el _list_contents
    bind --mode insert \el _list_contents

    bind --mode default \ei _toggle_private
    bind --mode insert \ei _toggle_private
end

function _fzf_cd_with_query
    set -l query (commandline)
    set -l result (fd -d 3 -H -t d -E .git -E node_modules -E .venv \
        | fzf --style=full --layout=reverse --query=$query)

    if test -n "$result"
        commandline -r ''
        cd $result
        commandline -f repaint
    else
        commandline -r $query
    end
end

function _fzf_history_search
    set -l query (commandline)
    set -l result (history \
        | awk '!seen[$0]++' \
        | fzf --style=full --layout=reverse --no-sort --query=$query)

    if test -n "$result"
        commandline -r $result
        commandline -f repaint
    else
        commandline -r $query
    end
end

function _fzf_history_search_sorted
    set -l query (commandline)
    set -l result (history \
        | awk '!seen[$0]++' \
        | fzf --style=full --layout=reverse --query=$query)

    if test -n "$result"
        commandline -r $result
        commandline -f repaint
    else
        commandline -r $query
    end
end

function _list_contents
    echo
    ls -lah
    commandline -f repaint
end

function _toggle_private
    if set -q fish_private_mode
        exit
    else
        fish --private
    end

    commandline -f repaint
end
