# fzf-powered reverse history search (Ctrl+R)
#
# Replaces the default zsh reverse-search with an fzf picker.
#
# Keybindings within fzf:
#   Enter       - select and immediately execute the command
#   Right arrow - select and paste into prompt (for editing before running)
#   Tab / S-Tab - navigate down / up
#   Ctrl+E      - toggle exact/fuzzy matching
#   Delete      - forget the highlighted entry (removes it from $HISTFILE)
#   Ctrl+Z      - undo the last delete (one level, .bak snapshot)
#   Ctrl+C      - cancel
#
# Requires: fzf

# fzf --zsh requires 0.48+; older versions hang waiting on stdin
if fzf --zsh &>/dev/null; then
  source <(fzf --zsh)
fi

fzf-execute-command() {
  local selected
  local action_file="/tmp/fzf_action"
  # Per-shell flag fzf-hist-rm touches when it actually deletes something.
  # Checked after fzf exits so we only clear+reload in-memory history when
  # a delete really happened.
  local hist_rm_flag="/tmp/fzf_hist_rm.$$"
  rm -f "$hist_rm_flag"
  export _FZF_HIST_RM_FLAG="$hist_rm_flag"

  # Pick a command from history using fzf
  # - fzf-hist-list reads HISTFILE and emits unique commands sorted by frecency
  #   (freq * recency-decay), highest first. Lines match the joined on-disk
  #   form so `fzf-hist-rm {}` can match exactly.
  # - --scheme=history: scoring tuned for command history; with a query typed,
  #   fzf ranks by match quality so a contiguous substring (e.g. `solat` in
  #   `cld attach solat`) beats scattered fuzzy hits regardless of frecency.
  # - --tiebreak=index: equal-score matches (and the empty query) fall back to
  #   fzf-hist-list's frecency order. --scheme=history implies this; explicit.
  # --listen 0 starts an HTTP control socket on a random port and exports
  # $FZF_PORT to subprocesses. fzf-hist-notify uses it to auto-clear the
  # header after 5s; without it, the "deleted:" / "restored:" message would
  # stick until the next action.
  selected=$(fzf-hist-list | fzf \
    --height 40% --border --layout=reverse-list \
    --scheme=history --tiebreak=index \
    --listen 0 \
    --prompt '> ' \
    --preview 'echo {}' --preview-window=up:3:hidden \
    --bind "tab:down,shift-tab:up,right:accept+execute-silent(echo right > $action_file),enter:accept+execute-silent(echo enter > $action_file)" \
    --bind 'ctrl-e:transform-query(fzf-toggle-exact {q})+transform-prompt([[ {fzf:prompt} == EXACT* ]] && echo "> " || echo "EXACT > ")' \
    --bind 'delete:execute-silent(fzf-hist-rm {})+transform-header(fzf-hist-notify deleted {})+reload(fzf-hist-list)' \
    --bind 'ctrl-z:transform-header(fzf-hist-undo)+reload(fzf-hist-list)' \
    --expect=ctrl-c 2>/dev/null)

  local exit_status=$?
  unset _FZF_HIST_RM_FLAG

  # If fzf-hist-rm actually removed an entry, refresh in-memory history from
  # the (already-edited) file so up-arrow / ^R don't resurrect deleted entries.
  # Guard on -s: if HISTFILE ever ended up empty/missing, keep whatever we
  # have in memory rather than nuking it.
  if [[ -f "$hist_rm_flag" ]]; then
    rm -f "$hist_rm_flag"
    if [[ -s "$HISTFILE" ]]; then
      local _saved_histsize=$HISTSIZE
      HISTSIZE=0
      HISTSIZE=$_saved_histsize
      fc -R "$HISTFILE"
    fi
  fi

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
bindkey '∂' fzf-cd-widget
