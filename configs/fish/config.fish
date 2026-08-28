set -g fish_history_max 32768

set -g fish_cursor_default bar
set -g fish_cursor_insert bar

starship init fish | source
zoxide init fish | source

# Allow mango (and other wlroots compositors) to fall back to software
# rendering when no hardware GL is available.
set -gx WLR_RENDERER_ALLOW_SOFTWARE 1

set -x LD_LIBRARY_PATH /home/grae/.local/lib/arch-mojo $LD_LIBRARY_PATH

# Pi
fish_add_path "/home/grae/.local/share/pi-node/node-v22.23.2-linux-x64/bin"

# Home Manager
fish_add_path "$HOME/.nix-profile/bin"
fish_add_path "$HOME/.local/state/nix/profiles/profile/bin"
