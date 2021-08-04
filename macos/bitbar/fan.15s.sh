#!/bin/zsh
# export PATH='/usr/local/bin:$PATH' # this is needed for BitBar on macOS when using bash above (ignores ~/.bash_profile) instead of zsh.
# using absolute path for v1 so the above does not matter:
/usr/local/opt/influxdb@1/bin/influx -execute 'SELECT "fan" FROM "telegraf"."autogen"."thermal" order by time desc limit 1' -format=csv | tail -n1 | cut -d, -f3
