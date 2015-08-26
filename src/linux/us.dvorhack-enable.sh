#!/usr/bin/env sh
# This script activate the custom keymap, which is expected to be located in $HOME/.config/xkb/symbols/dvorhack 
setxkbmap -I ~/.config/xkb dvorhack -print | xkbcomp -I$HOME/.config/xkb - $DISPLAY
