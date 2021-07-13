dockutil --remove 'Messages'
dockutil --remove 'Mail'
dockutil --remove 'FaceTime'
dockutil --remove 'Photos'
dockutil --remove 'Contacts'
dockutil --remove 'Keynote'
dockutil --remove 'Numbers'
dockutil --remove 'Pages'

dockutil --add /Applications/Google\ Chrome.app --after Safari
dockutil --add /Applications/iTerm.app --after 'Google Chrome'
dockutil --add /Applications/Spotify.app --after iTerm
dockutil --add /Applications/WhatsApp.app --after Spotify
dockutil --add /Applications/Slack.app --after WhatsApp
