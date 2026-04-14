#!/bin/sh
# Yank the output of the last command (text between the last two prompt lines).
# Prompts are detected by common markers: ➜ ❯ $ % #
# Pipes result to cb and notifies.

NIXDIR="${NIXDIR:-/nix}"
pane=$(tmux capture-pane -pS -)

# Find prompt line numbers (1-indexed).  Matches lines starting with optional
# whitespace then a prompt character, or containing user@host patterns.
prompt_lines=$(echo "$pane" | grep -n '^[[:space:]]*[➜❯$%#]' | cut -d: -f1)

# Need at least 2 prompt lines (previous command + current prompt)
count=$(echo "$prompt_lines" | grep -c .)
if [ "$count" -lt 2 ]; then
  tmux display-message "no command output found"
  exit 0
fi

# Last prompt = current (empty) prompt, second-to-last = the command that produced output
prev=$(echo "$prompt_lines" | tail -2 | head -1)
last=$(echo "$prompt_lines" | tail -1)

# Output is between prev+1 and last-1
start=$((prev + 1))
end=$((last - 1))

if [ "$start" -gt "$end" ]; then
  tmux display-message "last command had no output"
  exit 0
fi

echo "$pane" | sed -n "${start},${end}p" | "$NIXDIR/scripts/cb"
tmux display-message "output copied"
