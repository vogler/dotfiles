#!/bin/zsh
# export PATH='/usr/local/bin:$PATH' # this is needed for BitBar on macOS when using bash above (ignores ~/.bash_profile) instead of zsh.
rpi3=rpi3
# rpi3=192.168.178.3 # sometimes DNS lookup fails. why?
mosquitto_sub -h $rpi3 -t 'sensors/mh-z19b' -C 1 | jq .co2
