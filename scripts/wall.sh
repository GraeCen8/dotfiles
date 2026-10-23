#!/bin/sh
# wall.sh — pick a wallpaper from ~/dots/walls with wmenu and set it live:
# swaybg is restarted showing the picked image.
#
# Called from dwl: Super+Shift+W.
set -e

walls="$HOME/dots/walls"

# wmenu style — same Oxocarbon palette as menucmd in config.h
choice=$(for f in "$walls"/*; do
	[ -f "$f" ] && basename "$f"
done | wmenu -i -p 'wall:' \
	-f "JetBrainsMono Nerd Font Mono Bold 16" \
	-n "#f2f4f8" -N "#161616" \
	-m "#161616" -M "#78a9ff" \
	-s "#161616" -S "#78a9ff") || exit 0

[ -f "$walls/$choice" ] || exit 0

# restart swaybg with the picked wallpaper, detached from this script
pkill -x swaybg 2>/dev/null || true
sleep 0.3
setsid -f swaybg -i "$walls/$choice" -m fill >/dev/null 2>&1 &

if command -v dunstify >/dev/null 2>&1; then
	dunstify -a wall "Wallpaper set" "$choice"
elif command -v notify-send >/dev/null 2>&1; then
	notify-send -a wall "Wallpaper set" "$choice"
fi
