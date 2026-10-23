#!/bin/sh
# lock.sh — swaylock using the dwl Oxocarbon palette (config.def.h colors)
exec swaylock -f \
	--ignore-empty-password \
	--show-failed-attempts \
	--font "JetBrainsMono Nerd Font Mono" \
	--font-size 64 \
	--color 161616ff \
	--inside-color 16161600 \
	--ring-color 78a9ffff \
	--line-color 16161600 \
	--key-hl-color 78a9ffff \
	--bs-hl-color fa4d56ff
