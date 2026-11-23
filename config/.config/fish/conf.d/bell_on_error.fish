function bell_on_error --on-event fish_postexec
    test $status -ne 0; and printf '\a'
end
