#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

synclient HorizTwoFingerScroll=1

# OPAM configuration
. ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# add ruby gems to path (yeoman/grunt needs compass)
export PATH=$PATH:/home/ralf/.gem/ruby/2.0.0/bin

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
