#!/bin/sh
# snip.sh — screenshots via grim + slurp.
#   snip.sh        pick a region with the mouse, save + copy to clipboard
#   snip.sh full   whole screen, no picker
#
# Cancel the selection with Esc — nothing is taken.
#
# Save location: $SNIP_DIR (default ~/pictures/screenshots)
set -e

dir="${SNIP_DIR:-$HOME/pictures/screenshots}"
mkdir -p "$dir"
file="$dir/$(date +%Y%m%d-%H%M%S).png"

case "${1:-}" in
full)
	grim "$file"
	;;
*)
	# region snip — slurp exits non-zero on Esc; also guard against slurp
	# printing its cancellation text with a zero exit status
	geom="$(slurp)" || exit 0
	printf '%s' "$geom" | grep -qE '^[0-9]+,[0-9]+ [0-9]+x[0-9]+$' || exit 0
	grim -g "$geom" "$file"
	;;
esac

wl-copy < "$file"
if command -v dunstify >/dev/null 2>&1; then
	dunstify -a snip "Screenshot saved" "$file (copied to clipboard)"
elif command -v notify-send >/dev/null 2>&1; then
	notify-send -a snip "Screenshot saved" "$file (copied to clipboard)"
fi
