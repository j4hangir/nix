#!/usr/bin/env zsh
os=`$NIXDIR/utils/os_detect.sh`

# detach all other sessions but this one
alias takeover="tmux detach -a"

# recursive and verbose
alias mkdir="mkdir -pv"

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias hick='history | ack -i'
alias pu='pushd'
alias po='popd'

alias htop='sudo htop'

# get chmod code
alias gch="stat --format '%a'"

# kill process by cmd
alias ckill="pkill -f "

#** Nix specific 
# reload nix
alias nixre='$NIXDIR/init.sh' 
# update nix
alias nixpu='pushd $NIXDIR; git pull; popd; $NIXDIR/init.sh' 
alias nixdir='pushd $NIXDIR'

# define dummy `sudo` for distribus. that don't have, e.g. debian
if ! hash sudo 2>/dev/null; then
  sudo () {
    $@
  }
fi

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

trash () {
  if [ "$#" -le 0 ]; then
    echo "trash <files>"
    return
  fi
  if [[ $os == 'mac' ]]; then
    mv $@ ~/.Trash
  fi
}

opf () {
	if [[ $os == 'mac' ]]; then
		c="netstat -antvp tcp"
	else
		c="netstat -tulpn"
	fi
	if [ "$#" -le 0 ]; then
		eval "$c"
	else
		eval "$c | ack $@"
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
		#curl ifconfig.me
		return
	fi
#	echo $@
	if [[ $os == 'linux' ]]; then
		IP=$(getent hosts $@ | awk '{ print $1 }' | li) 
	elif [[ $os == 'mac' ]]; then
		IP=$(host $@ | awk '{ print $4 }') 
	fi
	echo $IP
	$(echo $IP | pbcopy > /dev/null 2>&1) 
}

# cp & mv pushd
__cpmvpd () {
	if [ "$#" -le 1 ]; then
		echo "Illegal number of parameters"
		return 
	fi
#	echo $@
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
		echo "ftar <fname> <path>"
		return
	fi
	fname=$1
	shift;
	tar -c --use-compress-program=pigz -f "$fname.tar.gz" "$@"
}

# toggle proxy
proxytoggle() {
	toggle=
	usage="Usage: proxytoggle {on|off,1|0}"
	if [ "$#" -lt 1 ]; then
    TOGGLE=$NIXDIR/.proxytoggle

    if [ ! -e $TOGGLE ]; then
      touch $TOGGLE
      toggle=1
    else
      rm $TOGGLE
      toggle=0
    fi
    #echo $usage
    #return
	elif [[ $1 == "on" || $1 == "1" ]]; then toggle=1
	elif [[ $1 == "off" || $1 == "0" ]]; then toggle=0
	else 
    echo $usage
    return
	fi
	SERVICES=
	for SERVICE in `networksetup -listallnetworkservices`; do
	 	if [ "`networksetup -getinfo $SERVICE | grep "IP address: [0-9]"`" != "" ]; then
			SERVICES="$SERVICES $SERVICE"
		fi
	done
	if [ "$SERVICES" = "" ]; then
		echo "no active network service"
		return 4
	fi
	# networksetup -setsocksfirewallproxy $SERVICE 127.0.0.1 $PORT off
	for SERVICE in $SERVICES; do
    SERVICE=`trim $SERVICE`
   	if [[ $toggle == 1 ]]; then 
      echo "$SERVICE -> 1"
      networksetup -setsocksfirewallproxystate $SERVICE on
    else
      echo "$SERVICE -> 0"
      networksetup -setsocksfirewallproxystate $SERVICE off
    fi
	done
}

# Run relative script with absolute path
.a () {
	echo -n `pwd`/$@
}

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# sort everything by size
alias dushs='dush * | sort -h'

alias ack='ack --color'

# install	colordiff package :)
alias diff='colordiff'

alias wget='wget -c'


# Count files
alias fcount="bash $NIXDIR/utils/count_files.sh"
alias count="bash $NIXDIR/utils/count_files_and_dirs.sh"

# Axel: default to alternate progress bar
alias axel="axel -n 10 -a"

# Download aliases
alias dl='axel -n 10 -a'
# wget resume by default

function getchmod {
 if [ "$#" -lt 1 ]; then
	 echo Usage: getchmod {FILE}
	 return
 fi
 if [[ $os == 'mac' ]]; then stat -f "%OLp" $@;
 else stat -c %a $@
 fi
}

function substitute {
 if [ -z "$1" -o -z "$2" ]; then
 echo "Usage: substitue FROM_STRING TO_STRING [OPTION]..."
 echo
 echo "Replace all occurances of FROM_STRING (a sed-compatible regular"
 echo "expression) with TO_STRING in all files for which ack-grep matches"
 echo "FROM_STRING."
 echo
 echo "Any additional options are passed directly to ack-grep (e.g.,"
 echo " --type=html would only run the substitution on html files)."
 return 1
 fi
 #
 FROM_STRING=${1/\//\\/}
 TO_STRING=${2/\//\\/}
 shift 2
 ack -l --print0 "$@" "$FROM_STRING" | xargs -0 -n 1 sed -i '' -e"s/$FROM_STRING/$TO_STRING/g"
}

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
		FILE="~/.nix/aliases.zsh"
		cp $FILE $FILE.bak
		grep -q "$LINE" "$FILE" || ( echo $alias aliased && awk '!found && /naliased:start/{on=1; found=1} on&&/naliased:end/{print "'$LINE'"; on=0} {print}' $FILE > $FILE.tmp)
		mv $FILE.tmp $FILE
		source $FILE
}

if [ -f ~/.nix/aliases.zsh ]; then
  source ~/.nix/aliases.zsh
fi
