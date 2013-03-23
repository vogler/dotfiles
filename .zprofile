#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

synclient HorizTwoFingerScroll=1

# OPAM configuration
. ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
