function fish_right_prompt
    set -l last_status $status
    set -l current_time (date +%I:%M:%S\ %p)

    if test $last_status -ne 0
        echo -n (set_color brred)"✘ $last_status "(set_color normal)
    end

    echo (set_color cyan)$current_time(set_color normal)
end
