#!/bin/sh
current=$(tmux display-message -p '#{window_index}')
lines=$(tmux list-windows -F '#{window_index}: #{window_name}')
total=$(echo "$lines" | wc -l | tr -d ' ')
pos=$(echo "$lines" | grep -n "^${current}:" | cut -d: -f1)
# fzf bottom-up: cursor starts at line 1 (bottom). target is (total - pos) ups from bottom.
ups=$((total - ${pos:-1}))
moves=""
i=0
while [ "$i" -lt "$ups" ]; do
  moves="${moves}+up"
  i=$((i + 1))
done
moves="${moves#+}"
bind="one:accept"
[ -n "$moves" ] && bind="${bind},start:${moves}"
window=$(echo "$lines" | fzf-tmux -p --no-sort --bind "$bind")
[ -n "$window" ] && tmux select-window -t "${window%%:*}"
