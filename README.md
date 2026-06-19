# dotfiles

macOS dotfiles

## Install

```sh
git clone https://github.com/digsy89/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` is idempotent — safe to re-run. It backs up any existing real files to `<file>.bak` before linking.

## Structure

Each tool gets its own topic directory.

```
dotfiles/
├── vim/
│   └── vimrc.symlink
├── zsh/
│   ├── zshrc.symlink
│   └── p10k.zsh.symlink
├── tmux/
│   └── tmux.conf.local.symlink
└── nvim/
    └── init.lua
```

**`*.symlink` files** are automatically discovered and linked to `$HOME/.<name>`.

**`nvim/`** is linked wholesale to `~/.config/nvim` since Neovim uses XDG config paths.

## Adding a new dotfile

1. Create a topic directory if needed (e.g., `git/`)
2. Add `<name>.symlink` inside it
3. Run `./install.sh`

For XDG-style configs (`~/.config/…`), add a `link` call in `install.sh`.

## Bootstrapped dependencies

| Tool | Notes |
|---|---|
| [Oh My Zsh](https://ohmyz.sh) | Installed to `~/.oh-my-zsh` |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Installed to `$ZSH_CUSTOM/themes/powerlevel10k` |
| [gpakosz/.tmux](https://github.com/gpakosz/.tmux) | Base tmux config cloned to `~/.tmux`; `tmux/tmux.conf.local.symlink` overrides it |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Installed to `~/.local/share/nvim/site/pack/themes/start/` |
