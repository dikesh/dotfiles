function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color brblue)(prompt_pwd)

    set_color -o
    if fish_is_root_user
        echo -n (set_color red)'# '
    end

    echo -n (set_color purple)(fish_git_prompt)

    set -l indicator (if test "$fish_bind_mode" = "insert"; echo "+"; else; echo "❯"; end)
    set -l indcolor (if set -q fish_private_mode; echo red; else; echo cyan; end)

    echo -n (set_color $indcolor)' '(echo $indicator)'❯❯ '(set_color --reset)
end
