#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
command -v zsh >/dev/null 2>&1 || $DIR/install_zsh.sh
LINE="source $DIR/init.sh"
#FILE=/etc/bashrc
FILE=/etc/zshrc

# Prefer prepending to preserve user configs and special aliases
# bashrc
grep -q "$LINE" "$FILE" || ( echo Prepending init.sh to $FILE && echo -e "$LINE\n$(cat $FILE)" > $FILE )
#source $FILE

# Prefer prepending to preserve user configs and special aliases
# vimrc
LINE="so $DIR/.vimrc"
FILE=~/.vimrc
grep -q "$LINE" "$FILE" || ( echo Prepending .vimrc to $FILE && echo -e "$LINE\n$(cat $FILE)" > $FILE )
