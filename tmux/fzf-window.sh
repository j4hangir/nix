#!/bin/sh
current=$(tmux display-message -p '#{window_index}')
lines=$(tmux list-windows -F '#{window_index}: #{window_name}')
pos=$(echo "$lines" | grep -n "^${current}:" | cut -d: -f1)
window=$(echo "$lines" | fzf-tmux -p --no-sort --select-1 --bind "start:down(${pos:-1})+up")
[ -n "$window" ] && tmux select-window -t "${window%%:*}"
