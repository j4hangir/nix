# Usage:
# source iterm2.zsh

DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"

# iTerm2 window/tab color commands
#   Requires iTerm2 >= Build 1.0.0.20110804
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
  source ~/.iTerm2-ssh.zsh 
# copy the following lines into .iTerm2-ssh.zsh
#if [[ -n "$ITERM_SESSION_ID" ]]; then
#  trap "tab-reset" INT EXIT
#  if [[ "$*" =~ "production|ec2-.*compute-1" ]]; then
#    tab-color 255 0 0
#  else
#    tab-color 0 255 0
#  fi
#fi
    ssh $*
}
compdef _ssh color-ssh=ssh

alias ssh=color-ssh
