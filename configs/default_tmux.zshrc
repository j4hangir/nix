# Auto-attach tmux on SSH login.
# Source this BEFORE p10k instant prompt / init.sh.
#
# - exit      → disconnects SSH
# - jailbreak  → kills tmux, drops to bare shell

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" && -t 0 ]]; then
  rm -f /tmp/.tmux_jailbreak_$(id -u)
  tmux new-session -A -s main
  [[ -f /tmp/.tmux_jailbreak_$(id -u) ]] && rm -f /tmp/.tmux_jailbreak_$(id -u) || exit
fi

