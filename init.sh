#!/usr/bin/env zsh
# idempotency guard — user zshrc may source this more than once
[[ -n "${_NIX_INIT_LOADED-}" ]] && return 0
typeset -g _NIX_INIT_LOADED=1

DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"

# ---------------------------------------------------------------------------
# p10k instant prompt — near the top, before any console output.
# Guarded so we don't re-source if the user's zshrc already did it.
# ---------------------------------------------------------------------------
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -z "${_p10k_instant_prompt_sourced-}" ]]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------
_nix_check() {
  command -v "$1" &>/dev/null && return 0
  echo "nix: $1 not found, skipping" >&2
  return 1
}

_nix_source() {
  [[ -f "$1" ]] && source "$1"
}

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
[[ ":$PATH:" != *":$DIR/scripts:"* ]] && PATH="$DIR/scripts:${PATH}"
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:${PATH}"

# ---------------------------------------------------------------------------
# 1. env vars
# ---------------------------------------------------------------------------
source "$DIR/envs.sh"

# ---------------------------------------------------------------------------
# 2. oh-my-zsh — configure BEFORE sourcing so OMZ sees our settings.
#    OMZ handles: fpath for each plugin, a single compinit, lib/*.zsh,
#    and each plugin.plugin.zsh.
# ---------------------------------------------------------------------------
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

# History vars set pre-OMZ so lib/history.zsh's floor checks are no-ops.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# User completion dir on fpath BEFORE compinit (OMZ or fallback).
[[ -d "$HOME/.zsh/completions" ]] && fpath=("$HOME/.zsh/completions" $fpath)

if [[ -d "$ZSH" ]]; then
  plugins=(
    git
    command-not-found
    colored-man-pages
    encode64
    colorize
    npm
    pip
    gem
    ruby
    python
    bundler
  )
  [[ "$(uname)" == "Darwin" ]] && plugins+=(brew macos)

  ZSH_THEME=""                     # p10k is sourced explicitly below
  DISABLE_AUTO_UPDATE=true         # no surprise prompts on shell start
  DISABLE_AUTO_TITLE=true          # MUST be set BEFORE OMZ; we roll our own
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
  ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
  mkdir -p "$ZSH_CACHE_DIR" "${ZSH_COMPDUMP:h}"

  source "$ZSH/oh-my-zsh.sh"
else
  # Graceful fallback if OMZ isn't installed: still get basic completions.
  autoload -U compinit && compinit -i
fi

# ---------------------------------------------------------------------------
# 3. post-OMZ overrides (setopts, history options, LS_COLORS, bashcompinit)
# ---------------------------------------------------------------------------
source "$DIR/configs/zshrc"

# ---------------------------------------------------------------------------
# 4. external plugins (not in OMZ, cloned to ~/.zsh/plugins by setup.sh)
# ---------------------------------------------------------------------------
ZSH_PLUGINS="$HOME/.zsh/plugins"
_nix_source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
_nix_source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
_nix_source "$ZSH_PLUGINS/powerlevel10k/powerlevel10k.zsh-theme"

# ---------------------------------------------------------------------------
# 5. aliases & functions (after plugins so we can override)
# ---------------------------------------------------------------------------
source "$DIR/aliases.zsh"

# ---------------------------------------------------------------------------
# 6. iterm2 ssh tab colors (macOS + iTerm only) — uses compdef
# ---------------------------------------------------------------------------
if [[ "$(uname)" == "Darwin" && "$TERM_PROGRAM" == "iTerm.app" ]]; then
  source "$DIR/iTerm2-ssh.zsh"
fi

# ---------------------------------------------------------------------------
# 7. conditional tool integrations
# ---------------------------------------------------------------------------
_nix_check fzf    && source "$DIR/fzf-history.zsh"
_nix_check zoxide && eval "$(zoxide init zsh)"

if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
elif command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
  alias bat='batcat'
fi

command -v nvim &>/dev/null && alias vim='nvim'

_nix_source "$DIR/utils/clipboard.zsh"

# ---------------------------------------------------------------------------
# 8. p10k config
# ---------------------------------------------------------------------------
[[ -f "$DIR/configs/p10k.zsh" ]] && source "$DIR/configs/p10k.zsh"

# ---------------------------------------------------------------------------
# 9. tmux / mosh env + terminal title
# ---------------------------------------------------------------------------
# set user once to avoid #(whoami) shell spawns in set-titles-string
[[ -n "$TMUX" ]] && tmux set -g @user "$(whoami)" 2>/dev/null

# detect mosh by parent process and propagate into tmux
if [[ -z "$TMUX" && $(ps -o comm= -p $PPID 2>/dev/null) == mosh-server ]]; then
  export NIX_MOSH=1
  tmux set-environment -g NIX_MOSH 1 2>/dev/null
fi
[[ -n "$NIX_MOSH" ]] && tmux set -g @mosh 1 2>/dev/null

# terminal title: full hostname outside tmux; tmux handles it inside.
# Roll our own because OMZ's %~ picks up p10k's $_p9k__cwd as a named dir
# (AUTO_NAME_DIRS) and prints "~_p9k__cwd" for deep paths.
if [[ -z "$TMUX" ]]; then
  _nix_set_title() { print -Pn "\e]0;%n@%M:${PWD/#$HOME/~}\a" }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _nix_set_title
  add-zsh-hook preexec _nix_set_title
fi

# prevent AUTO_NAME_DIRS from showing ~DIR in prompt
unset DIR ZSH_PLUGINS
