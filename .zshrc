#{{{ ZSH Modules

autoload -U compinit promptinit zcalc zsh-mime-setup
zsh-mime-setup
promptinit

zstyle ':completion:*' rehash true
if [[ -n "$ZSH_COMPDUMP" && -f "$ZSH_COMPDUMP" ]]; then
  source "$ZSH_COMPDUMP"
else
  compinit
fi

#}}}

#{{{ Options

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
setopt CORRECT

# This makes cd=pushd
setopt AUTO_PUSHD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
setopt GLOB_COMPLETE

setopt PUSHD_MINUS

# No more annoying pushd messages...
setopt PUSHD_SILENT

# blank pushd goes to home
setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.
setopt PUSHD_IGNORE_DUPS

# use magic (this is default, but it can't hurt!)
setopt ZLE

# Don't kill background jobs when I logout
setopt NO_HUP

# GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot.
setopt globdots

# Do not exit on end-of-file. 10 consecutive EOFs will still exit.
setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# beeps are annoying
setopt NO_BEEP

# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER

# Case insensitive globbing
setopt NO_CASE_GLOB

#}}}

#{{{ History

HISTSIZE=1000000
SAVEHIST=1000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

#}}}

export EDITOR="vim"
export TERM="xterm-256color"

# fix annoying BG color on folders
LS_COLORS=$LS_COLORS:'ow=30;44:'
