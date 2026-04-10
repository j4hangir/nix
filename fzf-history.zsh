# fzf-powered reverse history search (Ctrl+R)
#
# Replaces the default zsh reverse-search with an fzf picker.
#
# Keybindings within fzf:
#   Enter       - select and immediately execute the command
#   Right arrow - select and paste into prompt (for editing before running)
#   Tab / S-Tab - navigate down / up
#   Ctrl+E      - toggle exact/fuzzy matching
#   Ctrl+C      - cancel
#
# Requires: fzf

export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'

source <(fzf --zsh)

fzf-execute-command() {
  local selected
  local action_file="/tmp/fzf_action"

  # Pick a command from history using fzf
  # - awk deduplicates while preserving recency order
  # - --scheme=history: scoring tuned for command history (prefix + recency bias)
  # - --tiebreak=index: recency breaks ties among equal scores
  selected=$(fc -rl 1 | awk '{$1=""; cmd=substr($0,2)} !seen[cmd]++ {print cmd}' | fzf \
    --height 40% --border --layout=reverse-list \
    --scheme=history --tiebreak=index \
    --prompt '> ' \
    --preview 'echo {}' --preview-window=up:3:hidden \
    --bind "tab:down,shift-tab:up,right:accept+execute-silent(echo right > $action_file),enter:accept+execute-silent(echo enter > $action_file)" \
    --bind 'ctrl-e:transform-query(fzf-toggle-exact {q})+transform-prompt([[ {fzf:prompt} == EXACT* ]] && echo "> " || echo "EXACT > ")' \
    --expect=ctrl-c)

  local exit_status=$?

  # Bail on Ctrl+C
  if [[ $exit_status -eq 130 || "$selected" == *"ctrl-c"* ]]; then
    rm -f "$action_file"
    zle redisplay
    return
  fi

  if [ -n "$selected" ]; then
    # Strip the fzf --expect header line
    selected="${selected#*$'\n'}"

    BUFFER="$selected"
    CURSOR=${#BUFFER}

    # Enter = execute immediately; Right = just paste into prompt
    if [ -f "$action_file" ]; then
      if grep -q 'enter' "$action_file"; then
        zle accept-line
      fi
      rm "$action_file"
    fi

    zle redisplay
  fi
}

zle -N fzf-execute-command
bindkey '^R' fzf-execute-command

# Remap fzf's Alt-C (cd widget) to Alt-D
bindkey -rM emacs '\ec'
bindkey '\ed' fzf-cd-widget
