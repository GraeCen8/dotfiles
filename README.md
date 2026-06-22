# dotfiles

Managed with GNU Stow.

## Included
- `nvim/`
- `alacritty/`
- `helix/`
- `zsh/`

## Install
```sh
./install.sh
```

## Manual
```sh
stow --target="$HOME" nvim alacritty helix zsh
```

## Notes
- This repo is set up to keep the Neovim history inside the `nvim/` package.
- Zsh includes `~/.zshrc`, `~/.zshenv`, and `~/.p10k.zsh`.
