# dcli

Declarative system config for my Omarchy setup. Packages and dotfiles managed by [dcli](https://gitlab.com/theblackdon/dcli).

## Fresh Install

```sh
# Install dcli
yay -S dcli-arch-git

# Clone this config
dcli repo clone

# Sync everything
sudo dcli sync
```

## Structure

```
~/.config/dcli/
├── config.yaml                  # Points to active host
├── hosts/
│   ├── pc.yaml                  # PC-specific config
│   └── shared/
│       └── common.yaml          # Shared config across hosts
├── modules/
│   ├── base.yaml                # Core packages (base, paru, fzf, etc.)
│   ├── emacs/                   # Doom Emacs
│   ├── kitty/                   # Kitty terminal
│   ├── helium/                  # Helium browser (AUR)
│   ├── hypr/                    # Hyprland config
│   ├── fish/                    # Fish shell aliases/functions
│   ├── nvim/                    # Neovim config
│   ├── helix/                   # Helix editor
│   ├── herdr/                   # Herdr
│   └── zed/                     # Zed editor
└── state/                       # Tracking data
```

Each module directory contains:
- `module.yaml` - description + settings
- `packages.yaml` - package list
- `dotfiles/` - configs synced to `~/.config/`

## Commands

### Sync

Apply config changes (installs missing packages, syncs dotfiles):

```sh
dcli sync              # Preview with --dry-run first
sudo dcli sync         # Needs sudo for package install
```

### Update

Update system packages:

```sh
sudo dcli update
```

### Module Management

```sh
dcli module list       # List all modules
dcli module enable     # Interactive TUI to enable
dcli module disable    # Interactive TUI to disable
```

### Package Management

```sh
dcli install <pkg>     # Install + add to config
dcli remove <pkg>      # Remove + untrack
dcli search            # Interactive package search
dcli find <pkg>        # Find where a package is defined
dcli merge             # Import existing installed packages into config
```

### Config Management

```sh
dcli status            # Show current config and sync status
dcli validate          # Check config for errors
dcli edit              # Interactive config file editor
dcli save-config       # Backup config
dcli restore-config    # Restore from backup
```

### Git

```sh
dcli repo init         # Initialize git for config
dcli repo push         # Commit + push changes
dcli repo pull         # Pull updates
```

## Adding a New Module

1. Create the directory:
   ```sh
   mkdir -p ~/.config/dcli/modules/myapp/dotfiles/myapp
   ```

2. Create `modules/myapp/module.yaml`:
   ```yaml
   description: My app config
   dotfiles_sync: true
   ```

3. Create `modules/myapp/packages.yaml`:
   ```yaml
   packages:
     - myapp
   ```

4. Add dotfiles to `modules/myapp/dotfiles/myapp/`

5. Enable in `hosts/shared/common.yaml` (or host-specific yaml):
   ```yaml
   enabled_modules:
     - myapp
   ```

6. Sync:
   ```sh
   dcli sync
   ```

## Hosts

The `pc.yaml` host imports `shared/common.yaml` for shared settings. To add a new host (e.g. laptop):

1. Copy pc.yaml: `cp hosts/pc.yaml hosts/laptop.yaml`
2. Edit `config.yaml`: change `host: laptop`
3. Customize `enabled_modules` as needed

## Backups

- Config backups auto-run before sync (kept in `state/config-backups/`)
- System backups use snapper (`sudo snapper list`)
- Restore with `dcli restore-config` or `dcli restore`
