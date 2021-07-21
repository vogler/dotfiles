#/bin/bash
# https://superuser.com/questions/229773/run-command-on-startup-login-mac-os-x
# https://stackoverflow.com/questions/6442364/running-script-upon-login-mac
mosquitto_sub -h rpi3 -t 'Macbook' | grep --line-buffered off | xargs -I{} osascript -e 'say "goodbye"' -e 'tell application "System Events" to sleep'
