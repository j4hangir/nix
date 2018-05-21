#!/usr/bin/env zsh
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
unsetopt autopushd

# ignore commands that start with space
setopt HIST_IGNORE_SPACE
SPATH=$DIR/scripts
[[ ":$PATH:" != *":$SPATH:"* ]] && PATH="$SPATH:${PATH}"
source $DIR/envs.sh
source $DIR/aliases.zsh
source $DIR/iTerm2-ssh.zsh
source $DIR/antigen.zsh
#source $DIR/.zshrc

# antigen bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle command-not-found
antigen bundle git
antigen bundle npm
antigen bundle pip
antigen bundle rvm
antigen bundle gem                # support for Ruby package manager
antigen bundle encode64
antigen bundle colorize # cat with syntax highlight (need python's Pygments)
antigen bundle colored-man-pages
antigen bundle github
antigen bundle brew
antigen bundle osx
antigen bundle rails
antigen bundle ruby
antigen bundle python
antigen bundle capistrano
antigen bundle bundler
antigen apply
#antigen use oh-my-zsh
#antigen use prezto
source $DIR/.zshrc
source $DIR/themes/powerlevel9k/powerlevel9k.zsh-theme


echo "                _          _    __   _              _       __  
__/\__  _ __   (_) __  __ (_)  / _| (_)   ___    __| |   _  \ \ 
\    / | '_ \  | | \ \/ / | | | |_  | |  / _ \  / _\` |  (_)  | |
/_  _\ | | | | | |  >  <  | | |  _| | | |  __/ | (_| |   _   | |
  \/   |_| |_| |_| /_/\_\ |_| |_|   |_|  \___|  \__,_|  (_)  | |
                                                            /_/ "
