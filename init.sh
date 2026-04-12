#!/usr/bin/env zsh
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"

# ---------------------------------------------------------------------------
# p10k instant prompt — should be near the top of .zshrc, before init.sh.
# Guard: only activate here if not already running (i.e. .zshrc didn't do it).
# ---------------------------------------------------------------------------
if [[ -z "${_p10k_instant_prompt_sourced-}" ]]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# ---------------------------------------------------------------------------
# helper: conditional loading with one-time notice
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
SPATH=$DIR/scripts
[[ ":$PATH:" != *":$SPATH:"* ]] && PATH="$SPATH:${PATH}"

# ---------------------------------------------------------------------------
# 1. env vars
# ---------------------------------------------------------------------------
source "$DIR/envs.sh"

# ---------------------------------------------------------------------------
# 2. shell options & completions
# ---------------------------------------------------------------------------
source "$DIR/configs/zshrc"

# ---------------------------------------------------------------------------
# 3. plugins (direct source — no plugin manager)
# ---------------------------------------------------------------------------
ZSH_PLUGINS="$HOME/.zsh/plugins"
OMZ_PLUGINS="${ZSH:-$HOME/.oh-my-zsh}/plugins"

# external (cloned by setup.sh)
_nix_source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
_nix_source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# oh-my-zsh plugins (already on disk via oh-my-zsh)
_nix_source "$OMZ_PLUGINS/command-not-found/command-not-found.plugin.zsh"
_nix_source "$OMZ_PLUGINS/colored-man-pages/colored-man-pages.plugin.zsh"
_nix_source "$OMZ_PLUGINS/encode64/encode64.plugin.zsh"
_nix_source "$OMZ_PLUGINS/colorize/colorize.plugin.zsh"
_nix_source "$OMZ_PLUGINS/npm/npm.plugin.zsh"
_nix_source "$OMZ_PLUGINS/pip/pip.plugin.zsh"
_nix_source "$OMZ_PLUGINS/gem/gem.plugin.zsh"
_nix_source "$OMZ_PLUGINS/ruby/ruby.plugin.zsh"
_nix_source "$OMZ_PLUGINS/python/python.plugin.zsh"
_nix_source "$OMZ_PLUGINS/bundler/bundler.plugin.zsh"

# macOS-only
if [[ "$(uname)" == "Darwin" ]]; then
  _nix_source "$OMZ_PLUGINS/brew/brew.plugin.zsh"
  _nix_source "$OMZ_PLUGINS/macos/macos.plugin.zsh"
fi

# theme
_nix_source "$ZSH_PLUGINS/powerlevel10k/powerlevel10k.zsh-theme"

# ---------------------------------------------------------------------------
# 4. aliases & functions (after plugins so we can override)
# ---------------------------------------------------------------------------
source "$DIR/aliases.zsh"

# ---------------------------------------------------------------------------
# 5. iterm2 ssh tab colors (macOS + iTerm only)
# ---------------------------------------------------------------------------
if [[ "$(uname)" == "Darwin" && "$TERM_PROGRAM" == "iTerm.app" ]]; then
  source "$DIR/iTerm2-ssh.zsh"
fi

# ---------------------------------------------------------------------------
# 6. conditional tool integrations
# ---------------------------------------------------------------------------

# fzf
_nix_check fzf && source "$DIR/fzf-history.zsh"

# zoxide — smarter cd (z, zi)
_nix_check zoxide && eval "$(zoxide init zsh)"

# bat → cat alias
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
elif command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
  alias bat='batcat'
fi

# nvim → vim alias
command -v nvim &>/dev/null && alias vim='nvim'

# clipboard
source "$NIXDIR/utils/clipboard.zsh"

# ---------------------------------------------------------------------------
# 7. p10k config
# ---------------------------------------------------------------------------
[[ -f "$DIR/configs/p10k.zsh" ]] && source "$DIR/configs/p10k.zsh"

# clean up — prevent AUTO_NAME_DIRS from showing ~DIR in prompt
unset DIR SPATH ZSH_PLUGINS OMZ_PLUGINS
