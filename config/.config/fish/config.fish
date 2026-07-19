if status is-interactive
    # Env
    set -gx FZF_DEFAULT_OPTS "--bind tab:down,shift-tab:up"

    # Aliases
    alias ll "ls -lah"
    alias lg lazygit
    alias pwgen "openssl rand -base64 24"

    # Zoxide
    zoxide init fish | source

    # Mise
    mise activate fish | source
end
