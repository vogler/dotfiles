#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# http://chneukirchen.org/dotfiles/.xsession
setxkbmap -layout 'us(altgr-intl),de(nodeadkeys)' \
  -option 'grp:alt_shift_toggle,compose:menu'

# map multimedia keys (see .xbindkeysrc)
xbindkeys

# touchpad (circular starts on right edge)
synclient HorizTwoFingerScroll=1
synclient CircularScrolling=1
# 0    All Edges
# 1    Top Edge
# 2    Top Right Corner
# 3    Right Edge
# 4    Bottom Right Corner
# 5    Bottom Edge
# 6    Bottom Left Corner
# 7    Left Edge
# 8    Top Left Corner
synclient CircScrollTrigger=3
synclient FastTaps=1

# config for external monitor
sh ~/xrandr.sh

# start additions if running inside VirtualBox
sh ~/vbox.sh

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
