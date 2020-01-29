#!/bin/bash
export PATH='/usr/local/bin:$PATH' # this is only needed for BitBar on macOS
mosquitto_sub -h rpi3 -t 'sensors/mh-z19b' -C 1 | jq .co2
