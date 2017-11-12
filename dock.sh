#!/usr/bin/env bash

##################
#
# -------->     arandr     <--------------
#
# Use `arandr` to do this graphically
####################


source $HOME/.profile

# zlap
if [[ $(hostname -s) = zlap ]]; then
  xrandr --output eDP1 --auto --primary
  ######
  # Office
  ######

  # B286HK Monitor
  # 4k is being stupid
  #xrandr --output DP2 --rate 30 --mode 3840x2160 --right-of eDP1

  # Not working, dock hardware bad?
  #randr --output DP2 --rate 60 --mode 1920x1080 --right-of eDP1 --primary

  #Asus
  #with 4k
  #xrandr --output HDMI1 --right-of DP2
  #4k workaround
  xrandr --output HDMI1 --auto --right-of eDP1

  # 3840x2160 at 60hz only over Display Port
  # 30hxz max over HDMI
  #xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1
  #xrandr --output DP3 --auto --right-of HDMI1
fi

# zbox
if [[ $(hostname -s) = zbox ]]; then
  # xrandr --output DFP1 --auto --primary
  # xrandr --output DFP5 --auto --pos 3840x500
  echo "Docking for zbox"
  xrandr --output DP-2 --primary --mode 3840x2160 --pos 0x1080 --rotate normal
  xrandr --output DP-0 --mode 3840x2160 --pos 3840x1080 --rotate normal

  # Third Monitor
  #xrandr --output HDMI-0 --mode 1920x1080 --pos 2880x0 --rotate normal

  # xrandr --output DP-2 --auto --primary
  # xrandr --output DP-0 --auto --right-of DP-2

  i3-msg workspace 1 && i3-msg move workspace to output DP-2
  i3-msg workspace 2 && i3-msg move workspace to output DP-0
  #i3-msg workspace 3 && i3-msg move workspace to output HDMI-0
  i3-msg workspace 1
  # i3-msg move workspace 1 to DP-2
  # i3-msg move workspace 2 to DP-0
  # i3-msg move workspace 3 to HDMI-0
fi

# Work computer
if [[ $(hostname -s) = zco* ]]; then
  #monitors
  #xrandr --output DP1-1 --auto --above eDP1 --primary
  #xrandr --output DP1-2 --auto --right-of DP1-1

  xrandr --output eDP1 --primary  --mode 1366x768 --pos 1216x1080 --rotate normal
  xrandr --output DP1-2 --mode 1920x1080 --pos 1920x0 --rotate normal
  xrandr --output DP1-1 --mode 1920x1080 --pos 0x0 --rotate normal
fi

# x settings, make sure caps lock is remapped.
~/.xinitrc

# Set numlock to on.
for t in /dev/tty[0-9]*; do setleds -D +num <$t; done 2>/dev/null
