$env.path ++= ["~/.local/bin"]

niri completions nushell | save -f ~/.niri.nu
zoxide init nushell | save -f ~/.zoxide.nu
uv generate-shell-completion nushell | save -f ~/.uv.nu
uvx --generate-shell-completion nushell | save -f ~/.uvx.nu
^mise activate nu | save -f ~/.mise.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
