#!/bin/sh
# Yank command output to clipboard.
# If a command is currently running (output after the last prompt with no
# trailing prompt), yank that. Otherwise yank the last completed command's
# output. Skips no-output commands like "yo" itself.

NIXDIR="${NIXDIR:-/nix}"
pane=$(tmux capture-pane -pS -)

notify () {
  gap=$1; suffix=$2
  tmux set -g @notify "#[fg=yellow,bold] yanked $gap line$([ "$gap" -ne 1 ] && echo s)$suffix"
  tmux refresh-client -S
  sleep 3
  tmux set -g @notify ""
  tmux refresh-client -S
}

(
# Find prompt line numbers (1-indexed).
prompt_lines=$(echo "$pane" | grep -n '^[[:space:]]*[➜❯$%#]' | cut -d: -f1)
[ -z "$prompt_lines" ] && exit 0

total_lines=$(echo "$pane" | wc -l | tr -d ' ')
last_prompt=$(echo "$prompt_lines" | tail -1)

# Running command: output exists after the last prompt line.
if [ "$last_prompt" -lt "$total_lines" ]; then
  start=$((last_prompt + 1))
  chunk=$(echo "$pane" | sed -n "${start},${total_lines}p")
  if echo "$chunk" | grep -q '[^[:space:]]'; then
    gap=$((total_lines - last_prompt))
    echo "$chunk" | "$NIXDIR/scripts/cb"
    notify "$gap" " (running)"
    exit 0
  fi
fi

# Otherwise walk backwards to the last prompt that had output after it.
count=$(echo "$prompt_lines" | grep -c .)
[ "$count" -lt 2 ] && exit 0

lines_list=$(echo "$prompt_lines" | sort -rn)
prev_start=""
for ln in $lines_list; do
  if [ -n "$prev_start" ]; then
    gap=$((prev_start - ln - 1))
    if [ "$gap" -gt 0 ]; then
      start=$((ln + 1))
      end=$((prev_start - 1))
      echo "$pane" | sed -n "${start},${end}p" | "$NIXDIR/scripts/cb"
      notify "$gap" ""
      exit 0
    fi
  fi
  prev_start=$ln
done
) &
