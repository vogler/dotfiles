#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title dash.log
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 💨

# Documentation:
# @raycast.description Edit dash.log
# @raycast.author Ralf Vogler
# @raycast.authorURL https://github.com/vogler

cd

vimr --nvim scp://pi@rpi3/dash.log # opens VimR.app

# The following were experiments to open nvim in iTerm:
# nvim scp://pi@rpi3/dash.log # only works in terminal, shows nothing in Raycast
# open -a iTerm ~/ssh-dash.sh # works; opens new tab in the most recent iTerm window and closes it on exit of nvim (content of file is just the line above)
# edit in remote instead of local nvim:
# ssh -t pi@rpi3 'nvim ~/dash.log'
