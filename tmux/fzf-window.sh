#!/bin/sh
current=$(tmux display-message -p '#{window_index}')
lines=$(tmux list-windows -F '#{window_index}: #{window_name}')
pos=$(echo "$lines" | grep -n "^${current}:" | cut -d: -f1)
moves=""
i=1
while [ "$i" -lt "${pos:-1}" ]; do
  moves="${moves}+down"
  i=$((i + 1))
done
moves="${moves#+}"
window=$(echo "$lines" | fzf-tmux -p --no-sort --select-1 ${moves:+--bind "start:${moves}"})
[ -n "$window" ] && tmux select-window -t "${window%%:*}"
