#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[dotfiles]${NC} $1"; }
warning() { echo -e "${YELLOW}[dotfiles]${NC} $1"; }

link() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warning "Backing up $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  info "Linked $dst"
}

# --- *.symlink files → $HOME/.<name> ---
while IFS= read -r -d '' src; do
  filename="$(basename "$src" .symlink)"
  link "$src" "$HOME/.$filename"
done < <(find "$DOTFILES" -name "*.symlink" -not -path "*/.git/*" -print0)

# --- Neovim: link entire nvim/ dir to ~/.config/nvim ---
link "$DOTFILES/nvim" "$HOME/.config/nvim"

# --- tokyonight.nvim ---
TOKYONIGHT_DIR="$HOME/.local/share/nvim/site/pack/themes/start/tokyonight.nvim"
if [ ! -d "$TOKYONIGHT_DIR" ]; then
  info "Installing tokyonight.nvim..."
  git clone --depth=1 https://github.com/folke/tokyonight.nvim "$TOKYONIGHT_DIR"
else
  info "tokyonight.nvim already installed, skipping"
fi

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  info "Homebrew already installed, skipping"
fi

# --- tmux binary ---
if ! command -v tmux &>/dev/null; then
  info "Installing tmux..."
  brew install tmux
else
  info "tmux already installed, skipping"
fi

# --- tmux (gpakosz/.tmux) ---
if [ ! -d "$HOME/.tmux" ]; then
  info "Cloning gpakosz/.tmux..."
  git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
  ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
  info "tmux base config linked"
else
  info "~/.tmux already exists, skipping clone"
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  info "Oh My Zsh already installed, skipping"
fi

# --- Powerlevel10k ---
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  info "Powerlevel10k already installed, skipping"
fi

info "Done! Restart your shell or run: source ~/.zshrc"
