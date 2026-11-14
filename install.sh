#!/usr/bin/env bash
# Sets up zsh + Oh My Zsh + Powerlevel10k, tmux, vim, Karabiner and iTerm on a Mac.
# Safe to run again: existing files are backed up to ~/.dotfiles-backup/<timestamp>/.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
say() { printf '\n\033[1;33m==> %s\033[0m\n' "$*"; }

# 1. Xcode command line tools (git, compilers)
if ! xcode-select -p >/dev/null 2>&1; then
  say "Installing Xcode command line tools — finish the popup, then re-run this script"
  xcode-select --install
  exit 1
fi

# 2. Homebrew + packages
if ! command -v brew >/dev/null && [[ ! -x /opt/homebrew/bin/brew ]]; then
  say "Installing Homebrew (asks for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
say "Installing packages from Brewfile"
brew bundle --file="$DOTFILES/Brewfile" || echo "(some packages failed — usually just apps you already installed by hand; continuing)"

# 3. Oh My Zsh, Powerlevel10k, zsh plugins
clone() { [[ -d "$2" ]] || git clone --depth=1 "$1" "$2"; }
say "Installing Oh My Zsh + theme + plugins"
clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 4. Symlink dotfiles into place
link() {
  local src="$DOTFILES/$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then return; fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/"
    echo "backed up $dst -> $BACKUP/"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"; echo "linked $dst"
}
say "Linking dotfiles"
link zshrc     "$HOME/.zshrc"
link p10k.zsh  "$HOME/.p10k.zsh"
link tmux.conf "$HOME/.tmux.conf"
link vimrc     "$HOME/.vimrc"
link karabiner "$HOME/.config/karabiner"

# 4b. Claude Code skills + private study notes (see README "Learning workflow")
say "Linking Claude Code skills"
for skill in "$DOTFILES"/claude/skills/*/; do
  name="$(basename "$skill")"
  link "claude/skills/$name" "$HOME/.claude/skills/$name"
done
if [[ ! -d "$HOME/learning/.git" ]]; then
  say "Cloning private study notes into ~/learning"
  git clone -q https://github.com/StuffByLiang/learning.git "$HOME/learning" \
    || echo "(couldn't clone — run 'gh auth login', then re-run this script)"
fi

# 5. Vim plugins
say "Installing vim plugins"
mkdir -p "$HOME/.vim/undo"
[[ -f "$HOME/.vim/autoload/plug.vim" ]] || curl -fsLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -Es -u "$HOME/.vimrc" +'PlugInstall --sync' +qa || true

# 6. macOS + iTerm preferences
say "Setting key repeat and iTerm options"
defaults write -g KeyRepeat -int 2               # fastest repeat the Settings slider allows
defaults write -g InitialKeyRepeat -int 15       # shortest delay the slider allows
defaults write -g ApplePressAndHoldEnabled -bool false   # hold j/k repeats instead of the accent menu
ITERM="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
if [[ -f "$ITERM" ]] && ! pgrep -xq iTerm2; then
  /usr/libexec/PlistBuddy -c "Set ':New Bookmarks:0:Option Key Sends' 2" "$ITERM" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Set ':New Bookmarks:0:Normal Font' 'MesloLGS-NF-Regular 13'" "$ITERM" 2>/dev/null || true
  echo "iTerm: Left Option = Esc+, font = MesloLGS NF"
else
  echo "iTerm is running or hasn't been opened yet — set these by hand in Settings → Profiles:"
  echo "  Text → Font: MesloLGS NF     Keys → General → Left Option key: Esc+"
fi

say "Done. Log out and back in (key repeat), then open iTerm."
echo "Karabiner: open it once and allow the driver + Input Monitoring when macOS asks."
