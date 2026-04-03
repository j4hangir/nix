#!/usr/bin/env zsh
DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd )"
unsetopt autopushd

SPATH=$DIR/scripts
[[ ":$PATH:" != *":$SPATH:"* ]] && PATH="$SPATH:${PATH}"

source "$DIR/envs.sh"
source "$DIR/aliases.zsh"
source "$DIR/iTerm2-ssh.zsh"
source "$DIR/antigen.zsh"

# antigen bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle command-not-found
antigen bundle git
antigen bundle npm
antigen bundle pip
antigen bundle rvm
antigen bundle gem                # Ruby package manager
antigen bundle encode64
antigen bundle colorize           # cat with syntax highlight (needs Pygments)
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

source "$DIR/.zshrc"
