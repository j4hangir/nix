#!/usr/bin/env zsh
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
unsetopt autopushd

# ignore commands that start with space
setopt HIST_IGNORE_SPACE
SPATH=$DIR/scripts
[[ ":$PATH:" != *":$SPATH:"* ]] && PATH="$SPATH:${PATH}"
source $DIR/envs.sh
source $DIR/aliases.sh
source $DIR/antigen.zsh
#source $DIR/.zshrc

# antigen bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle command-not-found
#antigen use oh-my-zsh
antigen use prezto


echo "                _          _    __   _              _       __  
__/\__  _ __   (_) __  __ (_)  / _| (_)   ___    __| |   _  \ \ 
\    / | '_ \  | | \ \/ / | | | |_  | |  / _ \  / _\` |  (_)  | |
/_  _\ | | | | | |  >  <  | | |  _| | | |  __/ | (_| |   _   | |
  \/   |_| |_| |_| /_/\_\ |_| |_|   |_|  \___|  \__,_|  (_)  | |
                                                            /_/ "
