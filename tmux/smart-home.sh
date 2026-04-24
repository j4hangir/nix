#!/usr/bin/env zsh
# 1st Home: jump past p10k prompt (prompt_char + dir + optional vcs) to the typed command.
# 2nd Home (cursor unmoved): jump to start of line.

state_x=$(tmux show-options -gqv @home_x)
state_y=$(tmux show-options -gqv @home_y)
cur_x=$(tmux display-message -p "#{copy_cursor_x}")
cur_y=$(tmux display-message -p "#{copy_cursor_y}")

if [[ -n $state_x && $cur_x == $state_x && $cur_y == $state_y ]]; then
    tmux send-keys -X start-of-line
    tmux set-option -g @home_x ""
    tmux set-option -g @home_y ""
    exit 0
fi

line=$(tmux display-message -p "#{copy_cursor_line}")

if [[ $line =~ '^(➜[[:space:]]+[^[:space:]]+([[:space:]]+git:\([^)]*\)([[:space:]]+[✗✓])?)?[[:space:]]+)' ]]; then
    target=${#match[1]}
else
    target=0
fi

tmux send-keys -X start-of-line
if (( target > 0 )); then
    tmux send-keys -N $target -X cursor-right
else
    tmux send-keys -X back-to-indentation
fi

tmux set-option -g @home_x "$(tmux display-message -p "#{copy_cursor_x}")"
tmux set-option -g @home_y "$(tmux display-message -p "#{copy_cursor_y}")"
