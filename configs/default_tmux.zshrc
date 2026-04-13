# Auto-attach tmux on SSH login.
# Source this BEFORE p10k instant prompt / init.sh.
#
# - exit      → disconnects SSH
# - jailfree  → kills tmux, drops to bare shell

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" && -t 0 ]]; then
  rm -f /tmp/.tmux_jailfree_$(id -u)
  tmux new-session -A -s main
  [[ -f /tmp/.tmux_jailfree_$(id -u) ]] && rm -f /tmp/.tmux_jailfree_$(id -u) || exit
fi

alias jailfree='touch /tmp/.tmux_jailfree_$(id -u) && tmux kill-session'
