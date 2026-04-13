# Auto-attach tmux on SSH login.
# Source this BEFORE p10k instant prompt / init.sh.
#
# - Detach (ctrl-b d) → back to bare shell
# - exit               → disconnects SSH
# - exit 1             → drops to bare shell (jailbreak)

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" && -t 0 ]]; then
  tmux new-session -A -s main
  [[ $? -eq 0 ]] && exit
fi
