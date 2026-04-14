#!/bin/sh
# Yank the output of the last command (text between prompt lines).
# Skips commands that produced no output (like "yo" itself).

NIXDIR="${NIXDIR:-/nix}"
pane=$(tmux capture-pane -pS -)

(
# Find prompt line numbers (1-indexed).
prompt_lines=$(echo "$pane" | grep -n '^[[:space:]]*[➜❯$%#]' | cut -d: -f1)

count=$(echo "$prompt_lines" | grep -c .)
[ "$count" -lt 2 ] && exit 0

# Walk backwards to find the last prompt that actually had output after it.
# (Skips no-output commands like "yo" itself.)
lines_list=$(echo "$prompt_lines" | sort -rn)
prev_start=""
for ln in $lines_list; do
  if [ -n "$prev_start" ]; then
    gap=$((prev_start - ln - 1))
    if [ "$gap" -gt 0 ]; then
      start=$((ln + 1))
      end=$((prev_start - 1))
      echo "$pane" | sed -n "${start},${end}p" | "$NIXDIR/scripts/cb"
      tmux set -g @notify "#[fg=yellow,bold] yanked $gap line$([ "$gap" -ne 1 ] && echo s)"
      tmux refresh-client -S
      sleep 3
      tmux set -g @notify ""
      tmux refresh-client -S
      exit 0
    fi
  fi
  prev_start=$ln
done
) &
