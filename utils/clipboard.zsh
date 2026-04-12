# cross-platform clipboard: cb (copy) and cbp (paste)
# macOS: pbcopy/pbpaste
# Linux (Wayland): wl-copy/wl-paste
# Linux (X11): xclip or xsel
# Remote/SSH: osc52copy (no paste)

if [[ "$(uname)" == "Darwin" ]]; then
  alias cb='pbcopy'
  alias cbp='pbpaste'
elif command -v wl-copy &>/dev/null; then
  alias cb='wl-copy'
  alias cbp='wl-paste'
elif command -v xclip &>/dev/null; then
  alias cb='xclip -selection clipboard'
  alias cbp='xclip -selection clipboard -o'
elif command -v xsel &>/dev/null; then
  alias cb='xsel --clipboard --input'
  alias cbp='xsel --clipboard --output'
else
  alias cb='osc52copy'
fi
