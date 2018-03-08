#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
command -v zsh >/dev/null 2>&1 || $DIR/install_zsh.sh
LINE="source $DIR/init.sh"
#FILE=/etc/bashrc
#FILE=/etc/zshrc
FILE=~/.zshrc

# Prefer prepending to preserve user configs and special aliases
# bashrc
#grep -q "$LINE" "$FILE" || ( echo Prepending init.sh to $FILE && echo -e "$LINE\n$(cat $FILE)" > $FILE )
grep -q "$LINE" "$FILE" || ( echo Appending init.sh to $FILE && echo "$LINE" >> $FILE )
#source $FILE

# Prefer prepending to preserve user configs and special aliases
# vimrc
LINE="so $DIR/.vimrc"
FILE=~/.vimrc
grep -q "$LINE" "$FILE" || ( echo Prepending .vimrc to $FILE && echo -e "$LINE\n$(cat $FILE)" > $FILE )


# Install plugins

#echo Installing/updating plugins

#if test -e "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"; then
#  (cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ && git pull)
#else
#  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#fi
echo Installing default packages
$DIR/installs.sh

echo Installing oh my zsh
$DIR/install_oh_my_zsh.sh

source ~/.zshrc


