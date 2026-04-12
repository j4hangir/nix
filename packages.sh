#!/usr/bin/env bash
set -eo pipefail

# ---------------------------------------------------------------------------
# packages.sh — install essential tools for the nix shell environment
# ---------------------------------------------------------------------------
# Detects the system package manager and installs only what's missing.
# Supported: brew (macOS/Linux), dnf (Fedora/RHEL), apt (Debian/Ubuntu), pkg (FreeBSD)

TOOLS="neovim bat fd ripgrep fzf zoxide delta tmux btop dust"

# binary name that proves a tool is installed
bin_for() {
  case $1 in
    neovim)  echo nvim ;;
    ripgrep) echo rg ;;
    delta)   echo delta ;;
    *)       echo "$1" ;;
  esac
}

# package name per manager (only where it differs from tool name)
pkg_for() {
  local tool=$1 pm=$2
  case "$pm:$tool" in
    brew:delta)          echo git-delta ;;
    dnf:fd)              echo fd-find ;;
    dnf:delta)           echo git-delta ;;
    apt-get:fd)          echo fd-find ;;
    apt-get:delta)       echo git-delta ;;
    pkg:fd)              echo fd-find ;;
    pkg:delta)           echo git-delta ;;
    apt-get:dust)        echo du-dust ;;
    pkg:dust)            echo du-dust ;;
    dnf:dust)            return 1 ;;   # not in EPEL — install manually
    *)                   echo "$tool" ;;
  esac
}

detect_pm() {
  for pm in brew dnf apt-get pkg; do
    if command -v "$pm" &>/dev/null; then
      echo "$pm"
      return
    fi
  done
}

install_with() {
  local pm=$1; shift
  case $pm in
    brew)     brew install "$@" ;;
    dnf)      sudo dnf install -y "$@" ;;
    apt-get)  sudo apt-get install -y "$@" ;;
    pkg)      sudo pkg install -y "$@" ;;
  esac
}


# ---------------------------------------------------------------------------

PM=$(detect_pm)
if [ -z "$PM" ]; then
  echo "No supported package manager found (brew, dnf, apt-get, pkg)."
  echo "Install manually: $TOOLS"
  exit 1
fi

echo "Using: $PM"
echo

to_install=""
skipped=""
installed=""

for tool in $TOOLS; do
  bin=$(bin_for "$tool")
  if command -v "$bin" &>/dev/null; then
    skipped="$skipped $tool"
  elif pkg=$(pkg_for "$tool" "$PM"); then
    to_install="$to_install $pkg"
    installed="$installed $tool"
  fi
done

# trim leading space
to_install="${to_install# }"
skipped="${skipped# }"
installed="${installed# }"

if [ -z "$to_install" ]; then
  echo "Everything already installed."
  exit 0
fi

[ -n "$skipped" ] && echo "already present: $skipped"
echo
echo "Will install (via $PM):"
for pkg in $to_install; do
  echo "  $pkg"
done
echo
read -rp "Proceed? [y/N] " ans
case "$ans" in
  [Yy]*) ;;
  *)     echo "Aborted."; exit 0 ;;
esac
echo

# shellcheck disable=SC2086
install_with "$PM" $to_install || {
  failed=""
  for tool in $installed; do
    bin=$(bin_for "$tool")
    command -v "$bin" &>/dev/null || failed="$failed $tool"
  done
  failed="${failed# }"
  installed=""
  for tool in $TOOLS; do
    bin=$(bin_for "$tool")
    command -v "$bin" &>/dev/null && installed="$installed $tool"
  done
  installed="${installed# }"
}


# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo
[ -n "$installed" ] && echo "installed: $installed"
[ -n "$skipped" ]   && echo "already present: $skipped"
[ -n "${failed:-}" ]    && echo "failed/unavailable: $failed"

# Debian/Ubuntu quirks
if [ "$PM" = "apt-get" ]; then
  command -v batcat  &>/dev/null && echo "note: bat binary is 'batcat' on Debian/Ubuntu — handled by init.sh"
  command -v fdfind  &>/dev/null && echo "note: fd binary is 'fdfind' on Debian/Ubuntu — handled by init.sh"
fi
