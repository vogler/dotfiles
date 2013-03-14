#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# map caps lock to escape
setxkbmap -option caps:escape
synclient HorizTwoFingerScroll=1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
