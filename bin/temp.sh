#!/bin/bash
export PATH='/usr/local/bin:$PATH' # this is only needed for BitBar on macOS
mosquitto_sub -h rpi3 -t 'sensors/bme280' -C 1 | jq .temperature
