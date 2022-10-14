dockutil --remove 'Messages'
dockutil --remove 'Mail'
dockutil --remove 'FaceTime'
dockutil --remove 'Photos'
dockutil --remove 'Contacts'
dockutil --remove 'Keynote'
dockutil --remove 'Numbers'
dockutil --remove 'Pages'
dockutil --remove 'Music'
dockutil --remove 'Podcasts'

dockutil --add /Applications/Google\ Chrome.app --replacing 'Google Chrome' --position 3
# dockutil --add /Applications/WhatsApp.app --replacing WhatsApp --position 4
dockutil --add ~/Applications/Chrome\ Apps.localized/WhatsApp.app --replacing WhatsApp --position 4
# dockutil --add /Applications/Spotify.app --replacing Spotify --position 5
dockutil --add ~/Applications/Chrome\ Apps.localized/Spotify.app --replacing Spotify --position 5
dockutil --add /Applications/iTerm.app --replacing iTerm --position 6
dockutil --add /Applications/Visual\ Studio\ Code.app --replacing 'Visual Studio Code' --position 7
dockutil --add /Applications/Slack.app --replacing Slack --position 8
dockutil --add ~/Applications/Autodesk\ Fusion\ 360.app --replacing 'Autodesk Fusion 360' --position 9
