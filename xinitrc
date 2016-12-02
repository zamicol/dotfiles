# ~/.xinitrc
# This file is sourced when running startx and
#    other programs which call xinit

xmodmap $HOME/.dotfiles/xmodmap 2>/dev/null
synclient CoastingSpeed=0
xbacklight -set 80

# Faster key repeat and delay
# Stolen from http://unix.stackexchange.com/a/216238/40449
xset r rate 250 60
