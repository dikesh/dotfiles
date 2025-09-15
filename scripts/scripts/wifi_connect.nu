#!/usr/bin/env nu

# Inputs
let username = (gum input --header "Username:")
let password = (gum input --password --header "Password:")

# Remove existing connection
if $username in (nmcli con show | detect columns | where TYPE == "wifi" | get NAME) {
  nmcli connection delete $username
}
# Connect
nmcli device wifi connect $username password $password
