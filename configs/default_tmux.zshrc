# Auto-attach tmux on SSH login.
# Source this BEFORE p10k instant prompt / init.sh.
#
# - Detach (ctrl-b d) → back to bare shell
# - Exit                → disconnects SSH
# - TMUX_JAILFREE=1     → exit tmux without disconnecting
#   Set in ~/.zshenv for permanent, or export inside tmux for one-off.

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" && -t 0 ]]; then
  tmux new-session -A -s main && [[ -z "$TMUX_JAILFREE" ]] && exit
fi
