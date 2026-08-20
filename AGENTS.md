# AGENTS.md

## Project

Declarative system configuration for an Omarchy (Arch Linux) desktop managed by [dcli](https://gitlab.com/theblackdon/dcli). This repo lives at `~/.config/dcli/`.

## Structure

```
config.yaml              # Points to active host (host: pc)
hosts/
  pc.yaml                # PC host - imports shared/common.yaml
  shared/
    common.yaml          # Shared settings across all hosts
modules/
  base.yaml              # Core packages (always installed)
  <name>/
    module.yaml          # Description + dotfiles_sync flag
    packages.yaml        # Package list
    dotfiles/            # Configs symlinked to ~/.config/
```

## Rules

### Package names
- Use **pacman package names**, not AUR helper names (e.g. `helium-browser-bin`, not `paru -S helium-browser-bin`)
- Flatpak packages use `flatpak:` prefix: `flatpak:com.spotify.Client`
- Check `pacman -Ss <name>` or `paru -Ss <name>` to verify package names exist

### Module format
Each module is a directory under `modules/` with at minimum `module.yaml`:

```yaml
# modules/myapp/module.yaml
description: What this module does
dotfiles_sync: true    # Only if module has dotfiles/
```

```yaml
# modules/myapp/packages.yaml
packages:
  - myapp-package
```

Modules without dotfiles (e.g. `helium`) skip `dotfiles_sync` and the `dotfiles/` directory.

### Dotfiles
- Dotfiles live in `modules/<name>/dotfiles/<app>/`
- With `dotfiles_sync: true`, dcli symlinks contents to `~/.config/<app>/`
- Only one app directory per module's `dotfiles/` - no empty sibling dirs

### Host config
- `config.yaml` sets the active host
- Host files (`hosts/<name>.yaml`) can import shared configs via `import:`
- Imported files MUST have a `host:` key or dcli will fail to parse them
- Host-specific modules go in the host file, shared ones in `hosts/shared/common.yaml`

### Validation
Always validate before syncing:
```sh
dcli validate
```

### Syncing
Sync applies package installs and dotfile symlinks:
```sh
dcli sync --dry-run    # Preview first
sudo dcli sync         # Apply (needs sudo for packages)
```

## Common Tasks

### Add a new module
1. `mkdir -p modules/<name>/dotfiles/<app>` (if has config) or `mkdir modules/<name>` (packages only)
2. Create `modules/<name>/module.yaml`
3. Create `modules/<name>/packages.yaml`
4. If dotfiles: add config files to `dotfiles/<app>/`
5. Enable in `hosts/shared/common.yaml` or host-specific yaml
6. `dcli validate && sudo dcli sync`

### Add a package to an existing module
Edit `modules/<name>/packages.yaml`, add the package, then `sudo dcli sync`.

### Remove a module
1. Remove `modules/<name>/` directory
2. Remove from `enabled_modules` in host config
3. Remove symlink: `rm ~/.config/<app>`
4. `sudo dcli sync`

### Change dotfiles
Edit files directly in `modules/<name>/dotfiles/<app>/`, then `dcli sync` re-symlinks them.

## Gotchas

- dcli sync needs `sudo` for package installs - won't work in all terminal contexts
- Dotfile conflicts occur if two modules target the same `~/.config/<app>` path
- Imported host files without a `host:` key cause parse failures
- Empty directories in `dotfiles/` cause false conflict detection - keep only actual app dirs
- After editing module dotfiles, run `dcli sync` to re-link (manual edits to `~/.config/` are lost on sync)

## Git

```sh
git add -A && git commit -m "description"
# or per-module:
git add modules/<name>/ && git commit -m "Add <name> module"
```

Config is at `~/.config/dcli/`, git repo initialized there.
