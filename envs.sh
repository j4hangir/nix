#!/usr/bin/env zsh
# environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
export NIXDIR=$DIR
export EDTOR=$(which vim)
export PYTHONIOENCODING=utf8
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
# case-insenitive and colored
export LESS=-Ri

# if there is under one page, I don't need to press q to quit
export LESS=-FX

