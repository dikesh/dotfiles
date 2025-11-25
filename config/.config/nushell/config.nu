# Update config
$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}
$env.config.completions.algorithm = 'fuzzy'

# Aliases
alias ll = ls -a -s
alias lg = lazygit

# Custom commands
def --wrapped vi [...rest] {
  let params = $rest | str replace --regex '^~' $env.HOME
  if ("./.venv" | path exists) { uv run nvim ...$params } else { nvim ...$params }
}

def pwgen [] { openssl rand -base64 24 }

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD { cd $cwd }
	rm -fp $tmp
}

# Source completions and themes
source ~/.niri.nu
source ~/.zoxide.nu
source ~/.uv.nu
source ~/.uvx.nu
source ./themes/catppuccin_macchiato.nu
source ~/.cache/carapace/init.nu

# Update prompts
$env.PROMPT_COMMAND = {
  # Example: Red Nushell text, green current directory
  let dirs = pwd | str replace $env.HOME '~' | split row /
  let depth = $dirs | length
  let promt_path = $dirs | enumerate | each { |elt|
    if $elt.index == $depth - 1 {
      $elt.item
    } else {
      $elt.item | str substring 0..(if ($elt.item | str starts-with '.') {1} else {0})
    }
  } | str join /

  echo $"(ansi blue)($promt_path)(ansi reset)"
}

$env.PROMPT_INDICATOR_VI_NORMAL = $' (ansi cyan)❯❯❯(ansi reset) '
$env.PROMPT_INDICATOR_VI_INSERT = $' (ansi cyan)+❯❯(ansi reset) '
$env.PROMPT_COMMAND_RIGHT = { $"(ansi cyan)(date now | format date '%I:%M:%S %p')(ansi reset)" }

# Keybinding
$env.config.keybindings ++= [
  {
    name: change_dir_with_fzf
    modifier: ALT_CONTROL
    keycode: Char_f
    mode: [ vi_normal, vi_insert ]
    event: {
      send: ExecuteHostCommand,
      cmd: "fd -d 3 -H -t d -E .git -E node_modules -E .venv 
        | fzf --style=full --layout=reverse --query=(commandline)
        | if $in == '' {commandline edit (commandline)} else {commandline edit ''; cd $in}"
    }
  }
  {
    name: history_search_wo_sort
    modifier: CONTROL
    keycode: Char_r
    mode: [ vi_normal, vi_insert ]
    event: {
      send: ExecuteHostCommand,
      cmd: "history 
        | get command 
        | str trim 
        | reverse 
        | uniq 
        | to text 
        | fzf --style full --layout=reverse --no-sort --query=(commandline) 
        | if $in == '' {commandline edit (commandline)} else {commandline edit $in}"
    }
  }
  {
    name: history_search_w_sort
    modifier: ALT_CONTROL
    keycode: Char_r
    mode: [ vi_normal, vi_insert ]
    event: {
      send: ExecuteHostCommand,
      cmd: "history 
        | get command 
        | str trim 
        | reverse 
        | uniq 
        | to text 
        | fzf --style full --layout=reverse --query=(commandline) 
        | if $in == '' {commandline edit (commandline)} else {commandline edit $in}"
    }
  }
  {
    name: list_contents
    modifier: ALT
    keycode: Char_l
    mode: [ vi_normal, vi_insert ]
    event: { send: ExecuteHostCommand, cmd: "print ''; ls -a -s" }
  }
  {
    name: incognito
    modifier: ALT
    keycode: Char_i
    mode: [ vi_normal, vi_insert ]
    event: { send: ExecuteHostCommand, cmd: "nu --no-history" }
  }
]
