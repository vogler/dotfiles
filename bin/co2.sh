#!/bin/zsh
# export PATH='/usr/local/bin:$PATH' # this is needed for BitBar on macOS when using bash above (ignores ~/.bash_profile) instead of zsh.
# run via ssh for remote access (Host rpi3 defined in ~/.ssh/config)
ssh rpi3 mosquitto_sub -t 'sensors/mh-z19b' -C 1 | jq .co2
