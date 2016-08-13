#!/usr/bin/env bash

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi


# recursive and verbose
alias mkdir="mkdir -pv"

alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

if [[ $platform == 'linux' ]]; then
   alias ls='ls --color=auto'
   alias l.='ls -d .* --color=auto'
elif [[ $platform == 'freebsd' || $platform == 'darwin' ]]; then
   alias ls='ls -G'
   alias l.='ls -Gd .* -G'
fi

# process find
alias pf='ps aux | grep --color=auto'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ack='ack --color'

# install  colordiff package :)
alias diff='colordiff'

# Download aliases
alias dl='curl -O'
# wget resume by default
alias wget='wget -c'


# Disk usage
# disk usage, total, human and summarized
alias dush='du -chs'
