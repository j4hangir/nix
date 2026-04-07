#!/bin/sh
window=$(tmux list-windows -F '#{window_index}: #{window_name}' | fzf-tmux -p)
[ -n "$window" ] && tmux select-window -t "${window%%:*}"
