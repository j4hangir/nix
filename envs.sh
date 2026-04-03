#!/usr/bin/env zsh
# environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
export NIXDIR=$DIR
export EDITOR=$(which vim)
export PYTHONIOENCODING=utf8
export SCREENRC="$DIR/.screenrc"
# case-insensitive, colored, quit-if-one-screen, no-init
export LESS=-RiFX
