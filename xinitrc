# ~/.xinitrc
# This file is sourced when running startx and
#    other programs calling xinit

# printf "starting xinitrc"

xmodmap ~/.dotfiles/xmodmap 2>/dev/null
synclient CoastingSpeed=0 2>/dev/null
synclient VertEdgeScroll=0 2>/dev/null
synclient HorizEdgeScroll=0 2>/dev/null
#xbacklight -set 100

# Faster key repeat and delay
# Stolen from http://unix.stackexchange.com/a/216238/40449
xset r rate 250 60

# Always turn on numblock.  `numlockx` must be installed.  
numlockx
