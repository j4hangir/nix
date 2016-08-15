#!/usr/bin/env bash
os=`$NIXDIR/utils/os_detect.sh`
# recursive and verbose
alias mkdir="mkdir -pv"

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

if [[ $os == 'linux' ]]; then
   alias ls='ls --color=auto'
   alias l.='ls -d .* --color=auto'
elif [[ $os == 'freebsd' || $os == 'mac' ]]; then
   alias ls='ls -G'
   alias l.='ls -Gd .* -G'
fi

# process find
alias pf='ps aux | grep --color=auto'

# recurive mk and pushd
mkpd () {
  if [ "$#" -lt 1 ]; then
    echo "Illegal number of parameters"
    return
  fi
  for last; do true; done
  mkdir -pv $@
  pushd $last
}

# cp & pushd
__cpmvpd () {
  if [ "$#" -le 1 ]; then
    echo "Illegal number of parameters"
    return 
  fi
  echo $@
  $@
  # last arg
  for last; do true; done
  #penultimate = "${@:(-2):1}"
  if [[ -f $last ]]; then
    last=$(dirname "${last}") 
  fi 
  if [[ -d $last ]]; then
    pushd $last
  else
    echo "'$last' is not a directory!"
  fi
}

# cp & pushd
cpd () {
  __cpmvpd "cp" $@
}

# mv $ pushd
mvpd () {
  __cpmvpd "mv" $@
}




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


# Count files
alias fcount="bash $NIXDIR/utils/count_files.sh"
alias count="bash $NIXDIR/utils/count_files_and_dirs.sh"

# Cd to nix
alias cdnix="pushd $NIXDIR"



