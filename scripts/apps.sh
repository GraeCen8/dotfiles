#!/bin/sh
# App launcher for wmenu: lists installed applications from .desktop files
# instead of every executable on PATH, so non-GUI utilities (sh, ls, ...) don't
# pollute the menu. Any arguments override the built-in theming (see
# `wmenu -h`). Theme matches the sway/foot palette (IBM Carbon-ish):
# bg 161616, text dde1e6, accent 78a9ff, selection bg f2f4f8 / fg 161616.

menu_font="JetBrainsMono Nerd Font Mono Bold 12"
normal_bg=161616
normal_fg=dde1e6
want_bg=78a9ff
want_fg=161616
sel_bg=f2f4f8
sel_fg=161616

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

for d in /usr/local/share/applications /usr/share/applications \
	"${XDG_DATA_HOME:-$HOME/.local/share}/applications"; do
	for f in "$d"/*.desktop; do
		[ -f "$f" ] || continue
		grep -qE '^(NoDisplay|Hidden)=true' "$f" && continue
		id=${f##*/}
		id=${id%.desktop}
		name=$(awk -F= '/^Name=/{print $2; exit}' "$f")
		[ -n "$name" ] && printf '%s\t%s\n' "$name" "$id" >>"$tmp"
	done
done

choice=$(cut -f1 "$tmp" | sort |
	wmenu -i -p apps -f "$menu_font" \
		-N "$normal_bg" -n "$normal_fg" \
		-M "$want_bg" -m "$want_fg" \
		-S "$sel_bg" -s "$sel_fg" \
		"$@")
[ -n "$choice" ] || exit 0

# resolve Name back to the desktop file id and let gtk-launch deal with
# Exec field codes, Terminal=true, etc.
id=$(awk -F'\t' -v c="$choice" '$1 == c {print $2; exit}' "$tmp")
exec gtk-launch "$id"
