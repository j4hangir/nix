<p align="center">
  <pre align="center">
                _          _    __   _              _       __
  __/\__  _ __ (_) __  __ (_)  / _| (_)   ___    __| |   _  \ \
  \    / | '_ \| | \ \/ / | | | |_  | |  / _ \  / _` |  (_)  | |
  /_  _\ | | | || |  >  < | | |  _| | | |  __/ | (_| |   _   | |
    \/   |_| |_||_| /_/\_\|_| |_|   |_|  \___|  \__,_|  (_)  | |
                                                            /_/
  </pre>
</p>

<p align="center">
  <b>🐉 Personal shell environment that follows you everywhere</b>
</p>

<p align="center">
  <a href="#-quickstart"><img src="https://img.shields.io/badge/shell-zsh-informational?style=flat-square&logo=gnu-bash&logoColor=white" alt="zsh"></a>
  <a href="#-whats-inside"><img src="https://img.shields.io/badge/editor-vim-green?style=flat-square&logo=vim&logoColor=white" alt="vim"></a>
  <a href="#-whats-inside"><img src="https://img.shields.io/badge/multiplexer-tmux-orange?style=flat-square&logo=tmux&logoColor=white" alt="tmux"></a>
  <a href="#-platform-support"><img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20FreeBSD-blueviolet?style=flat-square" alt="platforms"></a>
</p>

---

## Prerequisites

Install these before running `setup.sh`:

```
zsh  git  curl  vim  tmux
```

## ⚡ Quickstart

```bash
git clone --recursive git@git.j4hangir.com:j4hangir/nix.git ~/nix
cd ~/nix
./setup.sh
```

That's it. `setup.sh` handles everything in one run:

- 🐚 Install [oh-my-zsh](https://ohmyz.sh) + shell plugins via [Antigen](https://github.com/zsh-users/antigen)
- 🔗 Wire up `~/.zshrc` and `~/.vimrc`

## 🔄 Daily Use

| Command | What it does |
|---|---|
| `nix-reload` | Re-source the entire shell config |
| `nix-update` | `git pull` + reload |
| `nix-cd` | Jump to the nix repo |

## 📦 What's Inside

### 🐚 Zsh

- **1M line history** with aggressive dedup, cross-session sharing, and instant append
- **Auto CD** — type a directory name to `cd` into it
- **Smart completion** — case-insensitive globbing, rehash on every completion
- **Plugins** — syntax highlighting, autosuggestions, git, npm, pip, ruby, and more

### ✏️ Vim

- Murphy colorscheme on 256 colors
- 2-space indentation, smart case search
- `j`/`k` move by visual lines
- Restore cursor position on reopen
- Modelines disabled for security

### 🖥️ Tmux

- **Prefix**: `Ctrl-U`
- **Dvorak-optimized** pane navigation — `h` / `t` / `n` / `s`
- Vi copy mode with `pbcopy` integration
- Mouse support, `|` and `-` to split, 30k line scrollback
- `Shift-H` to toggle pane logging

### 🛠️ Scripts

All live in `scripts/` and are added to `$PATH` automatically.

| Script | Description |
|---|---|
| `dh` | Delete history entries matching a pattern |
| `urlencode` | RFC 1738 URL encoding |
| `mrtorrent` | Convert magnet URIs to `.torrent` files |
| `on_wifi_change` | Auto-toggle proxy based on WiFi SSID |

Smaller utilities (`trim`, `ssh-fingerprint`, `mklink`, `adbscrshot`) are inlined as functions in `aliases.zsh`.

### 🧰 Aliases & Functions

<details>
<summary>📂 Navigation</summary>

```
..  ...  ....  .....     — quick upward navigation
cdl <dir>                — cd + ls
mkpu <dir>               — mkdir -p + pushd
pu / po                  — pushd / popd
```
</details>

<details>
<summary>🔍 Search & Process</summary>

```
pf <query>               — ps aux | grep
opf [filter]             — open ports (netstat)
hick <query>             — search history with ack
srch <name>              — mdfind wrapper (macOS)
```
</details>

<details>
<summary>📁 Files & Compression</summary>

```
gz <file>                — compress with pigz
ftar <name> <path>       — create .tar.gz with pigz
dush [path]              — human-readable disk usage
getchmod <file>          — show numeric permissions
```
</details>

<details>
<summary>🌐 Network</summary>

```
getip [host]             — show public IP or resolve hostname
proxytoggle [on|off]     — toggle SOCKS proxy per interface
dl <url>                 — download with axel (10 threads)
```
</details>

<details>
<summary>✨ Misc</summary>

```
nalias [-d desc] <name> <cmd>  — create persistent aliases
substitute <from> <to>         — find-and-replace across files
takeover                       — detach all other tmux sessions
```
</details>

## 🏗️ Architecture

```
~/.zshrc
  └── init.sh                    ← entrypoint
        ├── envs.sh              ← exports ($NIXDIR, $EDITOR, $LESS)
        ├── aliases.zsh          ← aliases & functions
        ├── iTerm2-ssh.zsh       ← iTerm2 tab colors for SSH
        ├── vendor/antigen.zsh   ← plugin manager (vendored)
        ├── antigen bundles      ← 19 plugins loaded
        └── .zshrc               ← zsh options, completions, keybindings

scripts/       → added to $PATH (standalone executables)
utils/         → helper scripts sourced by other files
tmux/          → dvorak.tmux.conf (sourced by .tmux.conf)
vendor/        → third-party files (antigen)
```

OS detection happens in `utils/os_detect.sh` and is stored in `$os`. Many aliases and functions branch on it for platform-specific behavior.

## 🖥️ Platform Support

| | macOS | Linux | FreeBSD |
|---|:---:|:---:|:---:|
| Core shell | ✅ | ✅ | ✅ |
| Aliases | ✅ | ✅ | ✅ |
| Spotlight search (`srch`) | ✅ | — | — |
| Proxy toggle | ✅ | — | — |

## 🔧 Environment Variables

| Variable | Purpose |
|---|---|
| `$NIXDIR` | Absolute path to this repo at runtime |
| `$NOTIVE_AUTH` | Auth token for the [notive](https://notive.j4hangir.com) push service |

## 📜 License

Personal dotfiles — use whatever you find useful.
