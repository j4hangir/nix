# This script will automatically set the tab-color in iTerm2
# iTerm2 window/tab color commands
#   Requires iTerm2 >= Build 1.0.0.20110804

DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
os=$($DIR/utils/os_detect.sh)

if [ "$os" != "mac" ]; then return; fi;


#   http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
tab-color() {
  echo -ne "\033]6;1;bg;red;brightness;$1\a"
  echo -ne "\033]6;1;bg;green;brightness;$2\a"
  echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
tab-reset() {
  echo -ne "\033]6;1;bg;*;default\a"
}

# Change the color of the tab when using SSH
# reset the color after the connection closes
color-ssh() {
  source ~/.nix/iTerm2-ssh.zsh 
  # copy the following lines into .iTerm2-ssh.zsh
  ssh $*
}

color-mosh() {
  source ~/.nix/iTerm2-ssh.zsh
  mosh $*
}

compdef _ssh color-ssh=ssh
compdef _mosh color-mosh=mosh

alias ssh=color-ssh
alias mosh=color-mosh
