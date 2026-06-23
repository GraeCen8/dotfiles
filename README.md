# dotfiles

Managed with GNU Stow.

## Included
- `nvim/`
- `nvim-main/`
- `nvim-based/`
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

## Neovim switcher
```sh
./toggle-nvim.sh        # toggle between nvim-main and nvim-based
./toggle-nvim.sh main   # force nvim-main
./toggle-nvim.sh based  # force nvim-based
```

## Notes
- `toggle-nvim.sh` copies the selected profile into `nvim/.config/nvim` and remembers the last active profile in your local state dir.
- Zsh includes `~/.zshrc`, `~/.zshenv`, and `~/.p10k.zsh`.
