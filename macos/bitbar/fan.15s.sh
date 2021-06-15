#!/bin/bash
# export PATH='/usr/local/bin:$PATH' # this is only needed for BitBar on macOS
/usr/local/opt/influxdb@1/bin/influx -execute 'SELECT "fan" FROM "telegraf"."autogen"."thermal" order by time desc limit 1' -format=csv | tail -n1 | cut -d, -f3
