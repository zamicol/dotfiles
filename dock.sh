#!/usr/bin/env bash

source $HOME/.profile

# zlap
if [[ $(hostname -s) = zlap ]]; then
 # Office
 xrandr --output DP-4 --auto --right-of LVDS1 --primary
 xrandr --output DP-2 --auto --right-of DP-4
fi

# zbox
if [[ $(hostname -s) = zbox ]]; then
 xrandr --output DFP1 --auto --primary
 xrandr --output DFP5 --auto --pos 3840x500
fi

# Work computer
if [[ $(hostname -s) = zco* ]]; then
	#monitors
  xrandr --output DP1-1 --auto --right-of eDP1 --primary
  xrandr --output DP1-2 --auto --right-of DP1-1

	#Remmina applet icon
	#remmina -i &
fi

# x settings, make sure caps lock is remapped.
~/.xinitrc

# Set numlock to on.
for t in /dev/tty[0-9]*; do setleds -D +num <$t; done
