#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
os=$("$DIR/utils/os_detect.sh")

if ! hash sudo 2>/dev/null; then
  sudo () { "$@"; }
fi

if [ "$os" = "mac" ]; then
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install reattach-to-user-namespace
  fi
  ins="brew"
elif [ "$os" = "linux" ]; then
  if command -v apt-get &>/dev/null; then
    ins="sudo apt-get"
  else
    ins="sudo yum"
  fi
fi

# axel: multi-threaded downloader
# nload: network load
# ack: better grep
# entr: on file-change reloads command
# mosh: mobile shell, nearly perfect replacement for SSH

packages="ncat tree axel entr ag ack ack-grep silversearcher-ag
epel-release.noarch the_silver_searcher nload htop pigz mosh mobile-shell git
tmux zsh vim mlocate p7zip p7zip-plugins nc psmisc sysstat bind-utils net-tools
unrar unrar-free fd fzf whois wget trash"

echo "Using $ins"

if [ "$ins" = "sudo apt-get" ]; then
  for p in $packages; do
    $ins install "$p" -y
  done
elif [ "$ins" = "brew" ]; then
  for p in $packages; do
    $ins install "$p"
  done
else
  $ins install $packages -y
fi
