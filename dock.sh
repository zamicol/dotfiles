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

#Work computer
if [[ $(hostname -s) = coll* ]]; then
	#monitors
  xrandr --output DP2 --auto --right-of eDP1 --primary
  xrandr --output HDMI1 --auto --right-of DP2

	#Remmina applet icon
	remmina -i &
fi
