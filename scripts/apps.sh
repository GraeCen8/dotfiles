#!/bin/sh
# App launcher for wmenu: lists installed applications from .desktop files
# instead of every executable on PATH, so non-GUI utilities (sh, ls, ...) don't
# pollute the menu. Any arguments override the built-in theming (see
# `wmenu -h`). Theme matches the sway/foot palette (IBM Carbon-ish):
# bg 161616, text dde1e6, accent 78a9ff, selection bg f2f4f8 / fg 161616.

# Height-matched to waybar: wmenu's bar height is just the font
# line-height + 2px (no padding), so the font must carry the whole height.
menu_font="JetBrainsMono Nerd Font Mono Bold 15px"
normal_bg=161616
normal_fg=dde1e6
want_bg=78a9ff
want_fg=161616
sel_bg=f2f4f8
sel_fg=161616

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# One awk pass over every .desktop file instead of forking grep+awk per file,
# which used to cost most of the launcher's startup time. find -print0 |
# xargs -0 (not shell globs) enumerates the files: missing directories don't
# abort with "no matches found" under zsh (which yielded an empty menu), and
# spaces in filenames like "F Product 2.desktop" don't get split. find errors
# for nonexistent dirs are silenced; xargs -0 -r skips awk when the list is
# empty. Files skipped: NoDisplay/Hidden=true; first Name= wins (localized
# Name[xx] lines are ignored because they don't match /^Name[=]/).
find /usr/local/share/applications /usr/share/applications \
	"${XDG_DATA_HOME:-$HOME/.local/share}/applications" \
	-maxdepth 1 -name '*.desktop' -print0 2>/dev/null |
	xargs -0 -r awk '
BEGINFILE { hide = 0; name = "" }
/^NoDisplay=true/ || /^Hidden=true/ { hide = 1; nextfile }
/^Name=/ { if (name == "") { sub(/^Name=[ \t]*/, ""); name = $0 } }
ENDFILE {
	if (!hide && name != "") {
		id = FILENAME
		sub(/\.desktop$/, "", id)
		sub(/.*\//, "", id)
		printf "%s\t%s\n", name, id
	}
}
' | sort -u >"$tmp"

choice=$(cut -f1 "$tmp" |
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
