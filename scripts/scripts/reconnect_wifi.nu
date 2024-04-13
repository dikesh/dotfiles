#!/usr/bin/env nu

let actions = [Reconnect Connect]
let action = (gum filter --header "Action:" ...$actions)
let username = (gum input --header "Username:")
let pwd = (gum input --password --header "Password:")

if $action == $actions.0 {nmcli connection delete $username}
nmcli device wifi connect $username password $pwd
