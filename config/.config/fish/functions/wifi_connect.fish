function wifi_connect
    # Inputs
    set -l username (gum input --header "Username:")
    set -l password (gum input --password --header "Password:")

    # Scan first
    nmcli device wifi rescan

    # Remove existing connection
    nmcli conn show | rg "^$username\s+"; and nmcli connection delete $username

    # Connect
    nmcli device wifi connect $username password $password
end
