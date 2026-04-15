#!/usr/bin/env zsh
os=$("$NIXDIR/utils/os_detect.sh")

# detach all other sessions but this one
alias takeover="tmux detach -a"
# escape tmux, drop to bare shell (see configs/default_tmux.zshrc)
alias jailbreak='touch /tmp/.tmux_jailbreak_$(id -u) && tmux detach'

# recursive and verbose
alias mkdir="mkdir -pv"

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias .5='cd ../../../../..'
alias hick='history | rg -i'
alias pu='pushd'
alias po='popd'

alias htop='sudo htop'

# kill process by cmd
alias ckill="pkill -f "


# which terminal we're in
alias whereami="ps -p $$; pwd -P"

#** Nix specific 
# reload nix
alias nix-reload='$NIXDIR/init.sh; [[ -n "$TMUX" ]] && tmux source-file $NIXDIR/configs/tmux.conf 2>/dev/null'
# update nix
alias nix-update='pushd $NIXDIR; git pull; popd; $NIXDIR/init.sh' 
alias nix-cd='pushd $NIXDIR'

# define dummy `sudo` for distribus. that don't have, e.g. debian
if ! hash sudo 2>/dev/null; then
  sudo () {
    "$@"
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

   # j4hangir: redefine mdfind and remove UserQueryParser superfluous msgs
   function mdfind() {
    /usr/bin/mdfind "$@" 2> >(grep --invert-match ' \[UserQueryParser\] ' >&2)
   }

	 srch() {
		 mdfind -name "$@"
	 }
fi

# process find
alias pf='ps aux | grep --color=auto -i'
# cd and ls
cdl () {
	cd "$1" && l
}

function find_bundle_name() {
  mdfind "kMDItemKind == 'Application'" | grep -i "$1" | head -1 | xargs -I {} defaults read {}/Contents/Info CFBundleIdentifier | tee >(pbcopy)
}

opf () {
	if [[ $os == 'mac' ]]; then
		local -a c=(netstat -antvp tcp)
	else
		local -a c=(netstat -tulpn)
	fi
	if [ "$#" -le 0 ]; then
		"${c[@]}"
	else
		"${c[@]}" | rg "$@"
	fi
}

# recurive mk and pushd
mkpu () {
	if [ "$#" -lt 1 ]; then
		echo "Illegal number of parameters"
		return
	fi
	for last; do true; done
	mkdir -pv "$@"
	pushd "$last"
}

getip () {
	if [ "$#" -le 0 ]; then
		echo Own IP:
		curl -w '\n' 'https://api.ipify.org'
		return
	fi
	if [[ $os == 'linux' ]]; then
		IP=$(getent hosts "$@" | awk '{ print $1 }' | li)
	elif [[ $os == 'mac' ]]; then
		IP=$(host "$@" | awk '{ print $4 }')
	fi
	echo "$IP"
	echo "$IP" | pbcopy > /dev/null 2>&1
}

# cp & mv pushd
__cpmvpd () {
	if [ "$#" -le 1 ]; then
		echo "Illegal number of parameters"
		return 
	fi
	"$@"
	for last; do true; done
	if [[ -f "$last" ]]; then
		last=$(dirname "${last}")
	fi
	if [[ -d "$last" ]]; then
		pushd "$last"
	else
		echo "'$last' is not a directory!"
	fi
}

# cp & pushd
cpd () {
	__cpmvpd "cp" "$@"
}

# mv $ pushd
mvpu () {
	__cpmvpd "mv" "$@"
}

# tar file, compress
gz () {
	if [ "$#" -lt 1 ]; then
		echo usage gz FILE
		return
	fi
	echo "Compressing $1.gz"
	pigz < "$1" > "$1.gz"
}

# Disk usage
# disk usage, total, human and summarized
dush () {
	if command -v dust &>/dev/null; then
		dust "${@:-.}"
	elif [ "$#" -lt 1 ]; then
		du -csh *
	else
		du -chs "$@"
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

    if [ ! -e "$TOGGLE" ]; then
      touch "$TOGGLE"
      toggle=1
    else
      rm "$TOGGLE"
      toggle=0
    fi
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
	echo -n "$(pwd)/$@"
}

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'


# install	colordiff package :)
alias diff='colordiff'

alias wget='wget -c'


# Count files
alias fcount="bash $NIXDIR/utils/count_files.sh"
alias count="bash $NIXDIR/utils/count_files_and_dirs.sh"

# Axel: default to alternate progress bar, 10 threads
alias axel="axel -n 10 -a"
alias dl='axel -n 10 -a'

function getchmod {
 if [ "$#" -lt 1 ]; then
	 echo Usage: getchmod {FILE}
	 return
 fi
 if [[ $os == 'mac' ]]; then stat -f "%OLp" "$@";
 else stat -c %a "$@"
 fi
}

function substitute {
 if [ -z "$1" -o -z "$2" ]; then
 echo "Usage: substitue FROM_STRING TO_STRING [OPTION]..."
 echo
 echo "Replace all occurances of FROM_STRING (a sed-compatible regular"
 echo "expression) with TO_STRING in all files for which rg matches"
 echo "FROM_STRING."
 echo
 echo "Any additional options are passed directly to rg (e.g.,"
 echo " --type=html would only run the substitution on html files)."
 return 1
 fi
 #
 FROM_STRING=${1/\//\\/}
 TO_STRING=${2/\//\\/}
 shift 2
 rg -l --null "$@" "$FROM_STRING" | xargs -0 -n 1 sed -i '' -e"s/$FROM_STRING/$TO_STRING/g"
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
		alias=$1
		shift
		desc=""
		if [ ! -z "$d" ]; then
			desc="\\n# $d\\n"; 
		fi
		LINE=$desc"alias $alias='$*'"
		FILE="$HOME/.nix/aliases.zsh"
		cp "$FILE" "$FILE.bak"
		local tmpfile
		tmpfile=$(mktemp)
		grep -q "$LINE" "$FILE" || ( echo "$alias aliased" && awk -v line="$LINE" '!found && /naliased:start/{on=1; found=1} on&&/naliased:end/{print line; on=0} {print}' "$FILE" > "$tmpfile")
		mv "$tmpfile" "$FILE"
		source "$FILE"
}

# yank last command output to clipboard (leading space excludes from history)
alias yo=" $NIXDIR/scripts/yo"

# one-liner utils (previously standalone scripts)
trim () { echo -e "$1" | awk '{$1=$1};1'; }
alias ssh-fingerprint='ssh-keygen -l -E md5 -f <(ssh-keyscan localhost 2>/dev/null)'
mklink () { cmd.exe /c "mklink /J ${1//\//\\} ${2//\//\\}"; }
adbscrshot () {
  if [ "$#" -le 0 ]; then
    adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' | imgcat
  else
    adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > "$1"
  fi
}

# tmnt — temporary SSHFS mount (remote → mac Finder)
# prints trigger marker for iTerm2 to auto-open tmnt-mount in a new tab
# iTerm2 trigger setup (one-time):
#   Regex:   \[tmnt:([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+:/[a-zA-Z0-9/._-]+)\]
#   Action:  Run Command
#   Command: $HOME/.nix/scripts/tmnt-trigger \1
tmnt () {
  if [ "$#" -lt 1 ]; then
    echo "usage: tmnt <path>"
    return 1
  fi
  local target="$1"
  if [[ -f "$target" ]]; then
    target="$(cd "$(dirname "$target")" && pwd -P)"
  elif [[ -d "$target" ]]; then
    target="$(cd "$target" && pwd -P)"
  else
    printf '\033[31mtmnt: %s not found\033[0m\n' "$target" >&2
    return 1
  fi
  local user="$(whoami)"
  local host="$(hostname)"
  local cmd="${user}@${host}:${target}"
  printf '\033[32mtmnt\033[0m %s\n' "$cmd"
  # trigger marker — print, let iTerm2/mosh process it, then erase
  # erasing removes it from tmux/mosh screen buffer so redraws won't re-trigger
  printf '[tmnt:%s]' "$cmd"
  sleep 0.1
  printf '\r\033[K'
}

# dtmnt — dismount tmnt mounts
if [[ $os == "mac" ]]; then
  dtmnt () {
    local any=0
    for mp in /Volumes/*(N); do
      # Finder SFTP mounts show as "smbfs" type with sftp:// source
      if ! mount | grep -q "on ${mp} .*smbfs"; then
        continue
      fi
      if [[ $# -ge 1 && "$mp" != *"$1"* ]]; then
        continue
      fi
      printf '\033[33munmounting\033[0m %s ... ' "$mp"
      if umount "$mp" 2>/dev/null || diskutil unmount "$mp" 2>/dev/null; then
        printf '\033[32mok\033[0m\n'
      else
        printf '\033[31mfailed\033[0m\n'
      fi
      any=1
    done
    if [[ $any -eq 0 ]]; then
      if [[ $# -ge 1 ]]; then
        printf '\033[31mno mount matching: %s\033[0m\n' "$1" >&2
        return 1
      fi
      printf '\033[2mno sftp mounts\033[0m\n'
    fi
  }
fi

if [ -f "$HOME/.nix/aliases.zsh" ]; then
  source "$HOME/.nix/aliases.zsh"
fi

return

