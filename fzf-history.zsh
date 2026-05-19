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

  # Frecency snapshot for this picker session. fzf-hist-rank reranks against
  # it on every keystroke; delete/undo regenerate it in place so it stays in
  # sync with HISTFILE.
  local hist_cache="/tmp/fzf_hist_cache.$$"
  fzf-hist-list > "$hist_cache"
  export _FZF_HIST_CACHE="$hist_cache"

  # Pick a command from history using fzf.
  # - fzf-hist-list emits unique commands ranked by frecency (freq *
  #   recency-decay), best first. Lines match the joined on-disk form so
  #   `fzf-hist-rm {}` can match exactly.
  # - change:reload runs fzf-hist-rank on every keystroke: it filters
  #   $hist_cache to the matching commands and reranks them by fzf match
  #   quality with a bounded recency lift, so a clearly better match still
  #   wins but recently-used commands get pulled up. Tune the recency weight
  #   via FZF_HIST_W_REC. Empty query just shows the frecency order.
  # - --no-sort keeps fzf from re-sorting fzf-hist-rank's output; fzf's own
  #   search stays enabled only so it highlights the matched characters
  #   (every reranked line already matches, so nothing gets filtered out).
  # --listen 0 starts an HTTP control socket on a random port and exports
  # $FZF_PORT to subprocesses. fzf-hist-notify uses it to auto-clear the
  # header after 5s; without it, the "deleted:" / "restored:" message would
  # stick until the next action.
  selected=$(fzf < "$hist_cache" \
    --height 40% --border --layout=reverse-list \
    --no-sort \
    --listen 0 \
    --prompt '> ' \
    --preview 'echo {}' --preview-window=up:3:hidden \
    --bind "tab:down,shift-tab:up,right:accept+execute-silent(echo right > $action_file),enter:accept+execute-silent(echo enter > $action_file)" \
    --bind 'change:reload(fzf-hist-rank {q})' \
    --bind 'ctrl-e:transform-query(fzf-toggle-exact {q})+transform-prompt([[ {fzf:prompt} == EXACT* ]] && echo "> " || echo "EXACT > ")+reload(fzf-hist-rank {q})' \
    --bind "delete:execute-silent(fzf-hist-rm {})+transform-header(fzf-hist-notify deleted {})+reload(fzf-hist-list > $hist_cache; fzf-hist-rank {q})" \
    --bind "ctrl-z:transform-header(fzf-hist-undo)+reload(fzf-hist-list > $hist_cache; fzf-hist-rank {q})" \
    --expect=ctrl-c 2>/dev/null)

  local exit_status=$?
  unset _FZF_HIST_RM_FLAG
  rm -f "$hist_cache"
  unset _FZF_HIST_CACHE

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
