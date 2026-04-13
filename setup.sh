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

# Wire default_tmux.zshrc into /etc/zprofile (system-wide, runs before .zshrc)
if [ "$(id -u)" = "0" ]; then
  LINE="source $DIR/configs/default_tmux.zshrc"
  FILE=/etc/zprofile
  if ! grep -qF "$LINE" "$FILE" 2>/dev/null; then
    read -p "Add tmux auto-attach to $FILE? [y/N] " ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
      echo "$LINE" >> "$FILE"
      echo "Wired default_tmux.zshrc into $FILE"
    fi
  fi
fi

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
# 3. Wire gitconfig (idempotent — uses git include, won't touch user.name/email)
# ---------------------------------------------------------------------------

GITCONFIG_PATH="$DIR/configs/gitconfig"
CURRENT_INCLUDE=$(git config --global --get include.path 2>/dev/null || true)
if [ "$CURRENT_INCLUDE" != "$GITCONFIG_PATH" ]; then
  git config --global include.path "$GITCONFIG_PATH"
  echo "Wired gitconfig include → $GITCONFIG_PATH"
fi

# ---------------------------------------------------------------------------
# 4. Symlink neovim config (idempotent)
# ---------------------------------------------------------------------------

NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [ ! -e "$NVIM_DIR" ]; then
  mkdir -p "$(dirname "$NVIM_DIR")"
  ln -sf "$DIR/configs/nvim" "$NVIM_DIR"
  echo "Linked neovim config → $NVIM_DIR"
elif [ "$(readlink "$NVIM_DIR" 2>/dev/null)" != "$DIR/configs/nvim" ]; then
  echo "Warning: $NVIM_DIR already exists and is not our symlink. Skipping nvim config."
fi

# ---------------------------------------------------------------------------
# 5. Symlink bundled treesitter parsers into user runtimepath
# ---------------------------------------------------------------------------
# Neovim searches {runtimepath}/parser/ but some installs (e.g. from-source
# to /usr/local) place .so files in /usr/local/lib/nvim/parser/ which isn't
# in the default runtimepath.  Symlink them so nvim can find them.

NVIM_BUNDLED_PARSERS="/usr/local/lib/nvim/parser"
NVIM_USER_PARSERS="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
if [ -d "$NVIM_BUNDLED_PARSERS" ]; then
  mkdir -p "$NVIM_USER_PARSERS"
  for so in "$NVIM_BUNDLED_PARSERS"/*.so; do
    [ -e "$so" ] || continue
    ln -sf "$so" "$NVIM_USER_PARSERS/"
  done
fi

# ---------------------------------------------------------------------------
# 6. Trust repo dir even if owned by another user (shared /nix installs)
# ---------------------------------------------------------------------------

git config --global --get-all safe.directory | grep -qxF "$DIR" \
  || git config --global --add safe.directory "$DIR"

# ---------------------------------------------------------------------------
# 7. Fix insecure completion dirs (suppress errors on first run)
# ---------------------------------------------------------------------------

if command -v zsh &>/dev/null; then
  zsh -c 'autoload -U compinit && compinit' 2>/dev/null || true
  zsh -c 'autoload -U compaudit && compaudit | xargs chmod g-w 2>/dev/null' 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 8. Clone zsh plugins (no plugin manager — just git clone + source)
# ---------------------------------------------------------------------------

ZSH_PLUGINS="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS"

clone_plugin() {
  local repo=$1 dir="$ZSH_PLUGINS/$2"
  if [ ! -d "$dir" ]; then
    echo "Cloning $repo..."
    git clone --depth 1 "https://github.com/$repo.git" "$dir"
  else
    echo "Updating $2..."
    git -C "$dir" pull --ff-only 2>/dev/null || true
  fi
}

clone_plugin zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting
clone_plugin zsh-users/zsh-autosuggestions zsh-autosuggestions
clone_plugin romkatv/powerlevel10k powerlevel10k

# ---------------------------------------------------------------------------
# 9. Install/update TPM (tmux plugin manager) — pinned
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
