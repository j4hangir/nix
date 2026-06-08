#!/bin/sh
# fzf picker to move the current window/tab to another slot via swap-window.
# Mirrors fzf-window.sh, but swaps positions instead of switching focus, then
# follows the moved window to its new index. Bound to prefix+m.
current=$(tmux display-message -p '#{window_index}')
lines=$(tmux list-windows -F '#{window_index}: #{window_name}#{?window_active, ←,}')
pos=$(echo "$lines" | grep -n "^${current}:" | cut -d: -f1)
ups=$(( ${pos:-1} - 1 ))
moves=""
i=0
while [ "$i" -lt "$ups" ]; do
  moves="${moves}+up"
  i=$((i + 1))
done
moves="${moves#+}"
bind="one:accept"
[ -n "$moves" ] && bind="${bind},load:${moves}"
dest=$(echo "$lines" | fzf --tmux --no-sort --prompt "swap → " --bind "$bind")
[ -n "$dest" ] || exit 0
d="${dest%%:*}"
tmux swap-window -s "$current" -t "$d" && tmux select-window -t "$d"
exit 0
