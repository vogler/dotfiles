#!/bin/bash
export PATH='/usr/local/bin:$PATH' # this is only needed for BitBar on macOS
rpi3=rpi3
rpi3=192.168.178.100 # sometimes DNS lookup fails. why?
mosquitto_sub -h $rpi3 -t 'sensors/mh-z19b' -C 1 | jq .co2
