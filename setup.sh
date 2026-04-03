#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/.nix
touch ~/.nix/iTerm2-ssh.zsh
echo "# naliased:start
alias hosts='sudo vim /etc/hosts'
# naliased:end" > ~/.nix/aliases.zsh

echo "null" > ~/.nix/.notive

command -v zsh >/dev/null 2>&1 || "$DIR/install_zsh.sh"

# Append init.sh to .zshrc
LINE="source $DIR/init.sh"
FILE=~/.zshrc
grep -q "$LINE" "$FILE" 2>/dev/null || ( echo "Appending init.sh to $FILE" && echo "$LINE" >> "$FILE" )

# Prepend .vimrc
LINE="so $DIR/.vimrc"
FILE=~/.vimrc
grep -q "$LINE" "$FILE" 2>/dev/null || ( echo "Prepending .vimrc to $FILE" && echo -e "$LINE\n$(cat "$FILE" 2>/dev/null)" > "$FILE" )

echo "Installing oh my zsh"
"$DIR/install_oh_my_zsh.sh"

echo "Cloning submodules"
git submodule update --init --recursive

source ~/.zshrc

compaudit | xargs chmod g-w

echo "Installing default packages"
"$DIR/installs.sh"
