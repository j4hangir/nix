#!/usr/bin/env bash
# environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export NIXDIR=$DIR
export EDTOR=$(which vim)
export PYTHONIOENCODING=utf8
export HISTCONTROL=ignoreboth:erasedups
