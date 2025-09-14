#!/usr/bin/env nu

let actions = [Reconnect Connect]
let action = (gum filter --header "Action:" ...$actions)
let username = (gum input --header "Username:")
try { if $action == $actions.0 {nmcli connection delete $username} }
nmcli device wifi connect $username password (gum input --password --header "Password:")
