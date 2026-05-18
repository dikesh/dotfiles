function xscreenshot -a selection
    switch $selection
        case screen
            grim -o (niri msg -j focused-output | jq -r .name) - | satty -f -
        case region
            grim -g (slurp) - | satty -f -
    end
end
