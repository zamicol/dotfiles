#!/usr/bin/env bash

# Use `arandr` to do this graphically

source $HOME/.profile

# zlap
if [[ $(hostname -s) = zlap ]]; then
  xrandr --output eDP1 --auto --primary
  # Office
  # B286HK Monitor
  #xrandr --output DP2 --rate 30 --mode 3840x2160 --right-of eDP1
  xrandr --output DP2 --rate 60 --mode 1920x1080 --right-of eDP1 --primary
  xrandr --output HDMI1 --right-of DP2
  # 3840x2160 at 60hz only over Display Port
  # 30hxz max over HDMI
  #xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1
  #xrandr --output DP3 --auto --right-of HDMI1
fi

# zbox
if [[ $(hostname -s) = zbox ]]; then
 xrandr --output DFP1 --auto --primary
 xrandr --output DFP5 --auto --pos 3840x500
fi

# Work computer
if [[ $(hostname -s) = zco* ]]; then
	#monitors
  #xrandr --output DP1-1 --auto --above eDP1 --primary
  #xrandr --output DP1-2 --auto --right-of DP1-1

  xrandr --output eDP1 --primary  --mode 1366x768 --pos 1216x1080 --rotate normal  --output DP1-2 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP1-1 --mode 1920x1080 --pos 0x0 --rotate normal
  # xrandr --output eDP1 --mode 1366x768 --pos 96x1080 --rotate normal
  # xrandr --output DP1-2 --mode 1920x1080 --pos 1920x0 --rotate normal
  # xrandr --output DP1-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
fi

# x settings, make sure caps lock is remapped.
~/.xinitrc

# Set numlock to on.
for t in /dev/tty[0-9]*; do setleds -D +num <$t; done
