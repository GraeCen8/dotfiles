#!/bin/sh
~/.config/mango/rebar.sh
swaybg -i ~/dots/walls/wall.jpg >/dev/null 2>&1 &

foot --server >/dev/null 2>&1 &
tmux new-session -d -s work >/dev/null 2>&1 &
