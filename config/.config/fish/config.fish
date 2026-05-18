if status is-interactive
    # Env
    set -gx FZF_DEFAULT_OPTS "--bind tab:down,shift-tab:up"
    set -gx VOLTA_HOME "$HOME/.volta"
    set -gx PATH "$VOLTA_HOME/bin" $PATH "$HOME/bin"

    # Aliases
    alias ll "ls -lah"
    alias lg lazygit
    alias pwgen "openssl rand -base64 24"

    # Zoxide
    zoxide init fish | source
end
