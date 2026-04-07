#!/bin/sh
current=$(tmux display-message -p '#{window_index}')
lines=$(tmux list-windows -F '#{window_index}: #{window_name}')
pos=$(echo "$lines" | grep -n "^${current}:" | cut -d: -f1)
pos=$((${pos:-1} - 1))
moves=""
i=0
while [ "$i" -lt "$pos" ]; do
  moves="${moves}+down"
  i=$((i + 1))
done
moves="${moves#+}"
bind="one:accept"
[ -n "$moves" ] && bind="${bind},start:${moves}"
window=$(echo "$lines" | fzf-tmux -p --no-sort --bind "$bind")
[ -n "$window" ] && tmux select-window -t "${window%%:*}"
