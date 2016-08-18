#!/usr/bin/env bash

#######
#######
#######

source $HOME/.profile

#zlap
if [[ $(hostname -s) = zlap ]]; then
 xrandr --output DP-2 --auto --right-of LVDS1 --primary
 xrandr --output DP-1 --auto --right-of DP-2
fi

#zbox
if [[ $(hostname -s) = zbox ]]; then
 xrandr --auto --output DFP1 --primary
fi

#Work computer
if [[ $(hostname -s) = coll* ]]; then
	#monitors
  xrandr --output DP2 --auto --right-of eDP1 --primary
  xrandr --output HDMI1 --auto --right-of DP2

	#Remmina applet icon
	remmina -i &
fi

#x settings, make sure caps lock is remapped.  
~/.xinitrc
