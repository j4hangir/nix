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
  fi
  ins="brew"
elif [ "$os" = "linux"]; then
  which -s yum
  if [[ $? != 0 ]] ; then
    ins="sudo apt-get"
  else
    ins="sudo yum"
  fi
fi

#echo $ins
$ins install -y tree
