#!/bin/sh
# wall.sh — switch wallpapers with a fuzzel picker (Super+Shift+w in mango)
#
# usage:
#   wall.sh              open the fuzzel picker
#   wall.sh <name|path>  set a wallpaper directly (substring match on name)
#
# env:
#   WALL_DIR  wallpaper directory (default: ~/.local/share/wallpapers)
#             (kept outside ~/dots, which is a git repo that gets cleaned)

WALL_DIR="${WALL_DIR:-$HOME/dots/walls/}"
STATE="$HOME/.config/mango/wall"       # last selected wallpaper (restored on startup)
PIDFILE="$HOME/.config/mango/wall.pid"

set_wall() {
    swaybg -i "$1" -m fill >/dev/null 2>&1 &
    new=$!
    sleep 0.15                          # let the new surface map, then kill the old
    if [ -f "$PIDFILE" ]; then
        kill "$(cat "$PIDFILE")" 2>/dev/null
    fi
    echo "$new" > "$PIDFILE"
    echo "$1" > "$STATE"
}

name_of() {                             # 001-lake-mist.jpg -> "001 lake mist"
    basename "$1" | sed -E 's/\.(jpe?g|png|webp)$//I' | tr '_-' '  '
}

case $# in
0)
    pick=$(ls -1 "$WALL_DIR" 2>/dev/null \
        | sed -E 's/\.(jpe?g|png|webp)$//I' | tr '_-' '  ' \
        | fuzzel --dmenu --prompt "wallpaper > " --lines 15 --minimal-lines \
                 --counter --only-match --no-run-if-empty --match-mode fzf)
    [ -n "$pick" ] || exit 0
    for f in "$WALL_DIR"/*; do
        [ -f "$f" ] || continue
        if [ "$(name_of "$f")" = "$pick" ]; then
            set_wall "$f"
            exit 0
        fi
    done
    echo "wall: no file matches '$pick'" >&2
    exit 1
    ;;
1)
    target=$1
    case $target in
    */*) ;;                           # contains a slash -> use as-is
    *)
        match=$(ls -1 "$WALL_DIR" 2>/dev/null | grep -iF -- "$target" | head -n 1)
        [ -n "$match" ] || {
            echo "wall: no wallpaper matching '$target'" >&2
            exit 1
        }
        target="$WALL_DIR/$match"
        ;;
    esac
    [ -f "$target" ] || {
        echo "wall: no such file: $target" >&2
        exit 1
    }
    set_wall "$target"
    ;;
*)
    echo "usage: wall.sh [name|path]" >&2
    exit 2
    ;;
esac
