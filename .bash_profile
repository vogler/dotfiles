#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


### SSH
# interrupts startx :(
# eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

# http://git.sysphere.org/dotfiles/tree/xinitrc
#eval `ssh-agent`
#(sleep 15 && keychain -q --timeout 480 --agents ssh id_rsa)&


# automatically startx on login on tty1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
