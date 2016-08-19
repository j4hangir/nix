#!/usr/bin/env zsh
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
   alias l='\ls --color=auto'
   alias ls='\ls --color=auto -lah'
   alias l.='\ls -d .* --color=auto'
elif [[ $os == 'freebsd' || $os == 'mac' ]]; then
   alias l='\ls -G'
   alias ls='\ls -G -lah'
   alias l.='\ls -Gd .* -G'
fi

# process find
alias pf='ps aux | grep --color=auto'
# cd and ls
cdl () {
  cd $1 && ls
}

# recurive mk and pushd
mkpu () {
  if [ "$#" -lt 1 ]; then
    echo "Illegal number of parameters"
    return
  fi
  for last; do true; done
  mkdir -pv $@
  pushd $last
}

# cp & mv pushd
__cpmvpd () {
  if [ "$#" -le 1 ]; then
    echo "Illegal number of parameters"
    return 
  fi
#  echo $@
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
mvpu () {
  __cpmvpd "mv" $@
}

# Disk usage
# disk usage, total, human and summarized
dush () {
  if [ "$#" -lt 1 ]; then
    du -csh *
  else
    du -chs $@
  fi
}

# get line #: li -1
li () {
  if [ "$#" -lt 1 ]; then
    head -n 1
  elif [ "$1" -lt 0 ]; then
    1=`expr -1 "*" $1`
    tail -n $1 | head -n 1
  else
    head -n $1 | tail -n 1
  fi
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


# Count files
alias fcount="bash $NIXDIR/utils/count_files.sh"
alias count="bash $NIXDIR/utils/count_files_and_dirs.sh"

# Cd to nix
alias cdnix="pushd $NIXDIR"

# Axel: default to alternate progress bar
alias axel="axel -n 10 -a"


# naliased:start
alias pyg='pushd /Users/racine/pygram'
# naliased:end


# new alias with optional description
nalias () {
 nalias_usage() { echo "nalias: [-d <arg>] alias cmd" 1>&2; return; }

  local OPTIND o d
  while getopts ":d:" o; do
      case "${o}" in
          d)
              d="${OPTARG}"
              ;;
          *)
              nalias_usage
              ;;
      esac
    done
    shift $((OPTIND-1))
    if [ "$#" -lt 2 ]; then
      nalias_usage
    fi
    # echo "d: [${d}], non-option arguments: $*"  
    alias=$1
    shift
    desc=""
    if [ ! -z "$d" ]; then
      desc="\\n# $d\\n"; 
    fi
    LINE=$desc"alias $alias='$*'"
    FILE="$NIXDIR/aliases.sh"
    cp $FILE $FILE.bak
    grep -q "$LINE" "$FILE" || ( echo $alias aliased && awk '!found && /naliased:start/{on=1; found=1} on&&/naliased:end/{print "'$LINE'"; on=0} {print}' $FILE > $FILE.tmp)
    mv $FILE.tmp $FILE
    source $FILE
}

