#!/bin/sh
~/.config/mango/rebar.sh
swaybg -i "$(cat ~/.config/mango/wall 2>/dev/null || echo ~/dots/walls/wall.jpg)" >/dev/null 2>&1 &
echo $! > ~/.config/mango/wall.pid

foot --server >/dev/null 2>&1 &
tmux new-session -d -s work >/dev/null 2>&1 &
