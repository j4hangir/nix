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

# Migrate stale pre-configs/ paths from older setup.sh versions
for pair in "$HOME/.vimrc:so $DIR/.vimrc" "$HOME/.tmux.conf:source $DIR/.tmux.conf"; do
  FILE="${pair%%:*}"; OLD="${pair#*:}"
  if [ -f "$FILE" ] && grep -qF "$OLD" "$FILE"; then
    echo "Removing stale '$OLD' from $FILE"
    grep -vF "$OLD" "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
  fi
done

# Prepend vimrc (idempotent)
LINE="so $DIR/configs/vimrc"
FILE=~/.vimrc
grep -qF "$LINE" "$FILE" 2>/dev/null || ( echo "Prepending vimrc to $FILE" && echo -e "$LINE\n$(cat "$FILE" 2>/dev/null)" > "$FILE" )

# Prepend tmux.conf (idempotent)
LINE="source $DIR/configs/tmux.conf"
FILE=~/.tmux.conf
grep -qF "$LINE" "$FILE" 2>/dev/null || ( echo "Prepending tmux.conf to $FILE" && echo -e "$LINE\n$(cat "$FILE" 2>/dev/null)" > "$FILE" )

# ---------------------------------------------------------------------------
# 3. Trust repo dir even if owned by another user (shared /nix installs)
# ---------------------------------------------------------------------------

git config --global --get-all safe.directory | grep -qxF "$DIR" \
  || git config --global --add safe.directory "$DIR"

# ---------------------------------------------------------------------------
# 4. Fix insecure completion dirs (suppress errors on first run)
# ---------------------------------------------------------------------------

if command -v zsh &>/dev/null; then
  zsh -c 'autoload -U compinit && compinit' 2>/dev/null || true
  zsh -c 'autoload -U compaudit && compaudit | xargs chmod g-w 2>/dev/null' 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 5. Install/update TPM (tmux plugin manager) — pinned
# ---------------------------------------------------------------------------

TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_TAG="v3.1.0"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM $TPM_TAG..."
  git clone --branch "$TPM_TAG" --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
elif [ "$(git -C "$TPM_DIR" describe --tags 2>/dev/null)" != "$TPM_TAG" ]; then
  echo "Updating TPM to $TPM_TAG..."
  git -C "$TPM_DIR" fetch --tags
  git -C "$TPM_DIR" checkout "$TPM_TAG" 2>/dev/null
fi

# Install/update tmux plugins (non-interactive, idempotent)
"$TPM_DIR/bin/install_plugins" 2>/dev/null || true
"$TPM_DIR/bin/update_plugins" all 2>/dev/null || true

echo "Done. Start a new zsh session or run: source ~/.zshrc"
