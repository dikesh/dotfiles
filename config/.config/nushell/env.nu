$env.path ++= ["~/.local/bin"]

niri completions nushell | save -f ~/.niri.nu
zoxide init nushell | save -f ~/.zoxide.nu
uv generate-shell-completion nushell | save -f ~/.uv.nu
uvx --generate-shell-completion nushell | save -f ~/.uvx.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

$env.VOLTA_HOME = ($nu.home-dir | path join ".volta")
$env.PATH = ($env.PATH | prepend ($env.VOLTA_HOME | path join "bin"))
