#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ---------------------------------------------------------------------------
# 1. Install oh-my-zsh (unattended — won't hijack the shell)
# ---------------------------------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ---------------------------------------------------------------------------
# 2. Wire up configs
# ---------------------------------------------------------------------------

mkdir -p ~/.nix
touch ~/.nix/iTerm2-ssh.zsh

if [ ! -f ~/.nix/aliases.zsh ]; then
  echo "# naliased:start
alias hosts='sudo vim /etc/hosts'
# naliased:end" > ~/.nix/aliases.zsh
fi

if [ ! -f ~/.nix/.notive ]; then
  echo "null" > ~/.nix/.notive
fi

# Append init.sh to .zshrc (idempotent)
LINE="source $DIR/init.sh"
FILE=~/.zshrc
grep -qF "$LINE" "$FILE" 2>/dev/null || ( echo "Appending init.sh to $FILE" && echo "$LINE" >> "$FILE" )

# Prepend .vimrc (idempotent)
LINE="so $DIR/.vimrc"
FILE=~/.vimrc
grep -qF "$LINE" "$FILE" 2>/dev/null || ( echo "Prepending .vimrc to $FILE" && echo -e "$LINE\n$(cat "$FILE" 2>/dev/null)" > "$FILE" )

# ---------------------------------------------------------------------------
# 3. Submodules
# ---------------------------------------------------------------------------

# trust the repo dir even if owned by another user (shared /nix installs)
git config --global --get-all safe.directory | grep -qxF "$DIR" \
  || git config --global --add safe.directory "$DIR"

if [ -w "$DIR" ]; then
  echo "Cloning submodules..."
  git -C "$DIR" submodule update --init --recursive
elif [ ! -d "$DIR/themes/powerlevel9k/.git" ]; then
  echo "Warning: submodules not initialised and $DIR is not writable."
  echo "Ask the repo owner to run: git -C $DIR submodule update --init --recursive"
fi

# ---------------------------------------------------------------------------
# 4. Fix insecure completion dirs (suppress errors on first run)
# ---------------------------------------------------------------------------

if command -v zsh &>/dev/null; then
  zsh -c 'autoload -U compinit && compinit' 2>/dev/null || true
  zsh -c 'autoload -U compaudit && compaudit | xargs chmod g-w 2>/dev/null' 2>/dev/null || true
fi

echo "Done. Start a new zsh session or run: source ~/.zshrc"
