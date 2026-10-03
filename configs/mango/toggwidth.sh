#!/bin/sh
state=/tmp/mango_width_full
if [ -f "$state" ]; then
    rm -f "$state"
    mmsg dispatch set_proportion,0.5
else
    touch "$state"
    mmsg dispatch set_proportion,1.0
fi
