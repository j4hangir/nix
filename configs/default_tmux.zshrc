# Auto-attach tmux on SSH login.
# Source this BEFORE p10k instant prompt / init.sh.
#
# - exit      → disconnects SSH
# - jailbreak  → kills tmux, drops to bare shell
# - NIX_NO_ATTACH=1 → skip auto-attach (used by cld --et so its cmd reaches
#   MAC_SESS directly instead of nesting inside master)

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" && -t 0 && -z "$NIX_NO_ATTACH" ]]; then
  rm -f /tmp/.tmux_jailbreak_$(id -u)
  tmux new-session -A -s master
  [[ -f /tmp/.tmux_jailbreak_$(id -u) ]] && rm -f /tmp/.tmux_jailbreak_$(id -u) || exit
fi

