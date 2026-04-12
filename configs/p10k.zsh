# Powerlevel10k configuration — lean style, ascii-only, 2-line prompt.
# Source this from .zshrc:  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  ##############################################################################
  # Instant prompt
  ##############################################################################
  # 'verbose' prints a warning if anything outputs before instant prompt.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  ##############################################################################
  # Core / style
  ##############################################################################
  typeset -g POWERLEVEL9K_MODE='ascii'

  # Lean style — no background colors, no powerline separators.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # --- Two-line prompt ---
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

  # Left / right segments
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(prompt_char dir vcs)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs context)

  # Segment separators — lean (empty).
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=''
  typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''

  # No segment background in lean style.
  typeset -g POWERLEVEL9K_BACKGROUND=''

  ##############################################################################
  # prompt_char — the input-line indicator (second line)
  ##############################################################################
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='➜ '
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION=':'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='^'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='  '
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=''

  ##############################################################################
  # Directory
  ##############################################################################
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=none
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

  # Writable / not-writable indicators
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  # Special directory colours (home, home subdirs, ETC, etc.)
  typeset -g POWERLEVEL9K_DIR_CLASSES=()

  ##############################################################################
  # VCS (git)
  ##############################################################################
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=166
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=196
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=244

  # Branch icon — ascii-safe.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''

  # Show detailed git status.
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # Formatting — branch name + status markers.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_format[1]))+${my_git_format[1]}}'

  # gitstatus — enable all counters.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  # Git status formatting function — called by p10k internally.
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # Already formatted (e.g., loading state).
      my_git_format=("$P9K_CONTENT")
      return
    fi

    local res
    local where

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      where=${(V)VCS_STATUS_LOCAL_BRANCH}
    elif [[ -n $VCS_STATUS_TAG ]]; then
      where="#${(V)VCS_STATUS_TAG}"
    else
      where="@${VCS_STATUS_COMMIT[1,8]}"
    fi

    res="${where//\%/%%}"  # escape percents

    # Upstream tracking — ahead/behind.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" %{%F{red}%}${VCS_STATUS_COMMITS_BEHIND}v%{%f%}"
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+=" %{%F{green}%}${VCS_STATUS_COMMITS_AHEAD}^%{%f%}"

    # Stashes.
    (( VCS_STATUS_STASHES )) && res+=" %{%F{cyan}%}*${VCS_STATUS_STASHES}%{%f%}"

    # Staged / unstaged / untracked / conflicted.
    (( VCS_STATUS_NUM_STAGED    )) && res+=" %{%F{green}%}+${VCS_STATUS_NUM_STAGED}%{%f%}"
    (( VCS_STATUS_NUM_UNSTAGED  )) && res+=" %{%F{yellow}%}!${VCS_STATUS_NUM_UNSTAGED}%{%f%}"
    (( VCS_STATUS_NUM_UNTRACKED )) && res+=" %{%F{blue}%}?${VCS_STATUS_NUM_UNTRACKED}%{%f%}"
    (( VCS_STATUS_NUM_CONFLICTED)) && res+=" %{%F{red}%}~${VCS_STATUS_NUM_CONFLICTED}%{%f%}"

    # Action (rebase, merge, cherry-pick, etc.).
    if [[ -n $VCS_STATUS_ACTION ]]; then
      res+=" %{%F{242}%}${VCS_STATUS_ACTION}%{%f%}"
    fi

    my_git_format=("$res")
  }
  functions -M my_git_formatter 2>/dev/null

  ##############################################################################
  # Status — exit code of previous command
  ##############################################################################
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  # OK — show nothing (clean prompt).
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true

  # Error — show the exit code.
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=196
  typeset -g POWERLEVEL9K_STATUS_ERROR_CONTENT_EXPANSION='%B${P9K_CONTENT}%b'

  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=false

  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=196

  ##############################################################################
  # Command execution time
  ##############################################################################
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  ##############################################################################
  # Background jobs
  ##############################################################################
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=70

  ##############################################################################
  # Context (user@host) — SSH only
  ##############################################################################
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=244
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=178

  # Show user@host only when connected via SSH (empty expansion hides it locally).
  typeset -g POWERLEVEL9K_CONTEXT_PREFIX=''
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m%b'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_CONTENT_EXPANSION='%n@%m'

  ##############################################################################
  # Transient prompt — collapse previous prompts to a minimal form
  ##############################################################################
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  ##############################################################################
  # Hot-reload — apply changes without restarting zsh (p10k reload)
  ##############################################################################
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
