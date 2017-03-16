#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
os=$($DIR/utils/os_detect.sh)
if [ "$os" = "mac" ]; then
  which -s brew
  if [[ $? != 0 ]] ; then
      # Install Homebrew
      #which -s ruby
      #if [[ $? != 0 ]] ; then
      #  yum install 
      # Install homebrew
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      
      # this makes pbcopy work in tmux: https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
      # taken from https://evertpot.com/osx-tmux-vim-copy-paste-clipboard/
      # https://seancoates.com/blogs/remote-pbcopy/
      brew install reattach-to-user-namespace -y
  fi
  ins="brew"
elif [ "$os" = "linux" ]; then
  which -s yum
  if [[ $? != 0 ]] ; then
    ins="sudo apt-get"
  else
    ins="sudo yum"
  fi
fi

# axel: multi-threaded downloader
# nload: network load
# ack: better grep
# entr: on file-change reloads command

packages="tree axel entr ack nload htop pigz"

$ins install $packages -y
