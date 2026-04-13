#!/usr/bin/env zsh
# environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
export NIXDIR=$DIR

# locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# editor — prefer neovim
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
else
  export EDITOR=$(which vim 2>/dev/null || echo vi)
fi

export PYTHONIOENCODING=utf8
export SCREENRC="$DIR/configs/screenrc"
export RIPGREP_CONFIG_PATH="$DIR/configs/ripgreprc"

# pager
export LESS=-RiFX
export PAGER="less -RiFX"
if command -v bat &>/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="ansi"
elif command -v batcat &>/dev/null; then
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  export BAT_THEME="ansi"
fi

# fzf
export FZF_DEFAULT_OPTS='--height 40% --border --layout=reverse'
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v fdfind &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# telemetry off
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1
export GATSBY_TELEMETRY_DISABLED=1
export ASTRO_TELEMETRY_DISABLED=1
export SAM_CLI_TELEMETRY=0
export AZURE_CORE_COLLECT_TELEMETRY=0
export POWERSHELL_TELEMETRY_OPTOUT=1

# mosh — suppress [mosh] prefix so tmux set-titles controls the full title
export MOSH_TITLE_NOPREFIX=1

# macOS-specific
[[ "$(uname)" == "Darwin" ]] && export HOMEBREW_NO_AUTO_UPDATE=1
