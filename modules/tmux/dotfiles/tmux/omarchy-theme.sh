#!/bin/sh
# Read Omarchy colors.toml and output tmux color variables
COLORS="$HOME/.local/state/omarchy/current/theme/colors.toml"
[ -f "$COLORS" ] || exit 0

get() { sed -n "s/^$1 *= *\"\([^\"]*\)\"/\1/p" "$COLORS"; }

cat <<EOF
# Auto-generated from Omarchy theme - do not edit
thm_bg="$(get background)"
thm_fg="$(get foreground)"
thm_cyan="$(get cyan)"
thm_black="$(get dark_background)"
thm_gray="$(get muted)"
thm_magenta="$(get magenta)"
thm_pink="$(get red)"
thm_red="$(get red)"
thm_green="$(get green)"
thm_yellow="$(get yellow)"
thm_blue="$(get blue)"
thm_orange="$(get orange)"
thm_black4="$(get selection)"
EOF
