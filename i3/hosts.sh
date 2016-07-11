#!/usr/bin/env bash

#######
#######
#######
#Put i3 host specific configs in this file.

#Work computer
if [[ $(hostname -s) = coll* ]]; then
	#monitors
  xrandr --output DP2 --auto --right-of eDP1
  xrandr --output HDMI1 --auto --right-of DP2

	#Remmina applet icon
	remmina -i &
fi
