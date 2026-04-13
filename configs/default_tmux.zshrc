# Auto-attach tmux on SSH login.
# Source this BEFORE p10k instant prompt / init.sh.
#
# - Detach (ctrl-b d) → drops to bare shell (session stays alive)
# - exit               → disconnects SSH (session gone)

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" && -t 0 ]]; then
  tmux new-session -A -s main
  tmux has-session -t main 2>/dev/null || exit
fi
