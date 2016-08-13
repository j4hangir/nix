#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LINE=source $DIR/init.sh
FILE=/etc/bashrc
grep -q "$LINE" "$FILE" || echo Adding init.sh to $FILE && echo "$LINE" >> "$FILE"
source $FILE
