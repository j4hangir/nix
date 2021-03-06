#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/.nix
touch ~/.nix/iTerm2-ssh.zsh
echo  "# naliased:start
alias hosts='sudo vim /etc/hosts'
#alias runcrun='run-parts /etc/cron.daily'
#alias flushdns='sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache'
# naliased:end" > ~/.nix/aliases.zsh

# default event
echo "null" > ~/.nix/.notive


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

echo Installing oh my zsh
$DIR/install_oh_my_zsh.sh

echo Cloning submodules
git submodule update --init --recursive
git submodule update --recursive 

source ~/.zshrc

# fix comp insecure directories
compaudit | xargs chmod g-w

echo Installing default packages
$DIR/installs.sh


