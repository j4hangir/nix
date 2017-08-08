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

alias htop='sudo htop'

# get chmod code
alias gch="stat --format '%a'"

if [[ $os == 'linux' ]]; then
   alias l='\ls --color=auto -tr'
   alias ls='\ls --color=auto -lahtr'
   alias l.='\ls -d .* --color=auto -tr'
elif [[ $os == 'freebsd' || $os == 'mac' ]]; then
   alias l='\ls -Gtr'
   alias ls='\ls -G -lahtr'
   alias l.='\ls -Gd .* -Gtr'
   alias updatedb='sudo /usr/libexec/locate.updatedb'
   srch() {
     mdfind -name $@ 
   }
fi

# process find
alias pf='ps aux | grep --color=auto -i'
# cd and ls
cdl () {
  cd $1 && l
}

opf () {
  if [[ $os == 'mac' ]]; then
    c="netstat -atp tcp"
  else
    c="netstat -tulpn"
  fi
  if [ "$#" -le 1 ]; then
    `$c`
  else
    `$c | ack $@`
  fi
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

getip () {
  if [ "$#" -le 0 ]; then
    echo Own IP:
    curl -w '\n' 'https://api.ipify.org'
    return
  fi
  echo $@
  IP=$(getent hosts $@ | awk '{ print $1 }' | li) 
  echo $IP
  $(echo $ip | pbcopy) 
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

# tar file, compress
gz () {
  if [ "$#" -lt 1 ]; then
    echo usage gz FILE
    return
  fi
  echo Compressing $1.gz
  pigz < $1 > $1.gz
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

# create tar.gz file
ftar () {
  if [ "$#" -lt 2 ]; then
    echo "ftar <fname> [path]"
    return
  fi
  fname=$1
  shift;
  tar -c --use-compress-program=pigz -f "$fname.tar.gz" "$@"
}

# Run relative script with absolute path
.a () {
  echo -n `pwd`/$@
}

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ack='ack --color'

# install  colordiff package :)
alias diff='colordiff'

alias wget='wget -c'


# Count files
alias fcount="bash $NIXDIR/utils/count_files.sh"
alias count="bash $NIXDIR/utils/count_files_and_dirs.sh"

# cd to nix
alias cdnix="pushd $NIXDIR"

# Axel: default to alternate progress bar
alias axel="axel -n 10 -a"

# Download aliases
alias dl='axel -n 10 -a'
# wget resume by default


# naliased:start
alias hosts='sudo vim /etc/hosts'
alias pip='pip3'
alias virtualenv='python3 Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/virtualenv.py'
alias runcrun='run-parts /etc/cron.daily'
# naliased:end


# create new alias with optional description
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

