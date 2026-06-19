#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[dotfiles]${NC} $1"; }
warning() { echo -e "${YELLOW}[dotfiles]${NC} $1"; }

backup_and_link() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warning "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  info "Linked $dst → $src"
}

# --- Shell ---
backup_and_link "$DOTFILES_DIR/zshrc"        "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/p10k.zsh"     "$HOME/.p10k.zsh"

# --- Vim ---
backup_and_link "$DOTFILES_DIR/vimrc"        "$HOME/.vimrc"

# --- Neovim ---
backup_and_link "$DOTFILES_DIR/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"

TOKYONIGHT_DIR="$HOME/.local/share/nvim/site/pack/themes/start/tokyonight.nvim"
if [ ! -d "$TOKYONIGHT_DIR" ]; then
  info "Installing tokyonight.nvim..."
  git clone --depth=1 https://github.com/folke/tokyonight.nvim "$TOKYONIGHT_DIR"
else
  info "tokyonight.nvim already installed, skipping"
fi

# --- tmux ---
backup_and_link "$DOTFILES_DIR/tmux.conf.local" "$HOME/.tmux.conf.local"

if [ ! -d "$HOME/.tmux" ]; then
  info "Cloning gpakosz/.tmux..."
  git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
  ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
  info "tmux base config linked"
else
  info "~/.tmux already exists, skipping clone"
fi

# --- Fish ---
backup_and_link "$DOTFILES_DIR/config/fish/config.fish" "$HOME/.config/fish/config.fish"

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
