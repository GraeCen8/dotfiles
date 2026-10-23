#!/bin/sh
# power.sh — power menu via wmenu.
#
# Offers the available power profiles (power-profiles-daemon) plus
# lock / reboot / poweroff. Cancel the menu to do nothing.
#
# Called from dwl: Super+Escape and Super+Backspace.
set -e

# wmenu style — same Oxocarbon palette as menucmd in config.h
choice=$(printf '%s\n' Performance Balanced Power-saver Lock Reboot Poweroff \
	| wmenu -i -p 'power:' \
		-f "JetBrainsMono Nerd Font Mono Bold 16" \
		-n "#f2f4f8" -N "#161616" \
		-m "#161616" -M "#78a9ff" \
		-s "#161616" -S "#78a9ff") || exit 0

case "$(printf '%s' "$choice" | tr '[:upper:]' '[:lower:]')" in
performance|balanced|power-saver)
	powerprofilesctl set "$choice"
	if command -v dunstify >/dev/null 2>&1; then
		dunstify -a power "Power profile" "$choice"
	elif command -v notify-send >/dev/null 2>&1; then
		notify-send -a power "Power profile" "$choice"
	fi
	;;
lock)
	exec "$HOME/dots/configs/dwl/scripts/lock.sh"
	;;
reboot)
	systemctl reboot
	;;
poweroff)
	systemctl poweroff
	;;
esac
