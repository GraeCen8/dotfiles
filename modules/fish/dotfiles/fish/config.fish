set -g fish_history_max 32768

set -g fish_cursor_default bar
set -g fish_cursor_insert bar

starship init fish | source
zoxide init fish | source

thefuck --alias | source
set -x LD_LIBRARY_PATH /home/grae/.local/lib/arch-mojo $LD_LIBRARY_PATH
