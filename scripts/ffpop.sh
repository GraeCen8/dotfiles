#!/bin/sh
# ffpop - fastfetch in a floating foot window, sized exactly to its output.
# How it works:
#   1. render fastfetch once in pipe mode (same layout as a real terminal,
#      just without color codes) and measure it in terminal cells
#   2. spawn foot with an app-id so niri floats it (window-rule in config.kdl),
#      with pad 0, no CSD, and the initial window size = the measured cells
#
# Optional: FF_POPUP_EXTRA_COLS / FF_POPUP_EXTRA_ROWS add slack, useful if
# glyphs in the output render 2 cells wide (emoji etc.).

APP_ID=fastfetch-popup

tmp=$(mktemp) || exit 1
trap 'rm -f "$tmp"' EXIT INT TERM

fastfetch --pipe true > "$tmp" || exit 1

rows=$(wc -l < "$tmp")
# strip ANSI/OSC escapes, then count rendered chars per line (gawk + UTF-8 locale)
cols=$(sed -E 's/\x1B\[[0-9;:]*[a-zA-Z]//g; s/\x1B\][^\x07]*(\x07|\x1B\\)//g; s/\r//g' "$tmp" \
    | LC_ALL=C.UTF-8 awk '{if (length($0) > m) m = length($0)} END {print m + 0}')

cols=$((cols + ${FF_POPUP_EXTRA_COLS:-0} + 2))
rows=$((rows + ${FF_POPUP_EXTRA_ROWS:-0}))

# use footclient instead when a foot server is running (opens instantly)
client=foot
sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/foot-${WAYLAND_DISPLAY:-wayland-1}.sock"
[ -S "$sock" ] && client=footclient

exec "$client" \
    -a "$APP_ID" \
    --title=fastfetch \
    -o main.pad=0x0 \
    -o csd.preferred=none \
    -o main.initial-window-size-chars="${cols}x${rows}" \
    sh -c 'fastfetch; read -r _'   # dismiss with Enter or the close-window bind
