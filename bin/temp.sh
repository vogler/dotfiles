#!/bin/zsh
# export PATH='/usr/local/bin:$PATH' # this is needed for BitBar on macOS when using bash above (ignores ~/.bash_profile) instead of zsh.
rpi3=rpi3
rpi3=192.168.178.100 # sometimes DNS lookup fails. why?
mosquitto_sub -h $rpi3 -t 'sensors/bme280' -C 1 | jq .temperature
