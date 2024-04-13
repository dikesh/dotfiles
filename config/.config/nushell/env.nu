zoxide init nushell | save -f ~/.zoxide.nu
uv generate-shell-completion nushell | save -f ~/.uv.nu
uvx --generate-shell-completion nushell | save -f ~/.uvx.nu

let mise_path = $nu.home-path | path join .mise.nu
^mise activate nu | save $mise_path --force

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
