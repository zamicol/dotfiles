#!/usr/bin/env bash

echo 'Turning off disconnected outputs.'
dis=`xrandr | grep  "disconnected" | awk '{print $1}'`
for d in $dis; do
  xrandr --output $d --off
  echo $d
done
