#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
os=$("$DIR/utils/os_detect.sh")

if ! hash sudo 2>/dev/null; then
  sudo () { "$@"; }
fi

# ---------------------------------------------------------------------------
# 1. Package manager setup & install packages
# ---------------------------------------------------------------------------

install_packages () {
  echo "Installing packages..."

  if [ "$os" = "mac" ]; then
    if ! command -v brew &>/dev/null; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    # reattach-to-user-namespace: makes pbcopy work in tmux
    brew install zsh vim tmux git mosh htop pigz tree wget whois \
      fzf fd the_silver_searcher ack axel entr nmap p7zip unrar \
      reattach-to-user-namespace trash 2>/dev/null || true

  elif [ "$os" = "linux" ]; then
    if command -v dnf &>/dev/null; then
      # RHEL / AlmaLinux / Fedora
      sudo dnf install -y epel-release 2>/dev/null || true
      sudo dnf install -y zsh vim tmux git mosh htop pigz tree wget whois curl \
        fzf fd-find the_silver_searcher ack nmap-ncat axel entr nload \
        p7zip p7zip-plugins psmisc sysstat bind-utils net-tools \
        mlocate unrar 2>/dev/null || true
    elif command -v yum &>/dev/null; then
      # older RHEL/CentOS without dnf
      sudo yum install -y epel-release 2>/dev/null || true
      sudo yum install -y zsh vim tmux git mosh htop pigz tree wget whois curl \
        fzf fd-find the_silver_searcher ack nmap-ncat axel entr nload \
        p7zip p7zip-plugins psmisc sysstat bind-utils net-tools \
        mlocate unrar 2>/dev/null || true
    elif command -v apt-get &>/dev/null; then
      # Debian / Ubuntu
      sudo apt-get update -y
      sudo apt-get install -y zsh vim tmux git mosh htop pigz tree wget whois curl \
        fzf fd-find silversearcher-ag ack axel entr nload \
        p7zip netcat-openbsd psmisc sysstat dnsutils net-tools \
        mlocate unrar trash-cli 2>/dev/null || true
    fi
  fi
}

install_packages

# ---------------------------------------------------------------------------
# 2. Install oh-my-zsh (unattended — won't hijack the shell)
# ---------------------------------------------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ---------------------------------------------------------------------------
# 3. Wire up configs
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
# 4. Submodules
# ---------------------------------------------------------------------------

echo "Cloning submodules..."
git -C "$DIR" submodule update --init --recursive

# ---------------------------------------------------------------------------
# 5. Fix insecure completion dirs (suppress errors on first run)
# ---------------------------------------------------------------------------

if command -v zsh &>/dev/null; then
  zsh -c 'autoload -U compinit && compinit' 2>/dev/null || true
  zsh -c 'autoload -U compaudit && compaudit | xargs chmod g-w 2>/dev/null' 2>/dev/null || true
fi

echo "Done. Start a new zsh session or run: source ~/.zshrc"
