# https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh
# https://macos-defaults.com
# https://mths.be/macos (goes to https://github.com/mathiasbynens/dotfiles/blob/main/.macos)

echo "The following settings have to be changed manually:" # TODO set some of these somehow? `defaults -currentHost read -g` shows changes to be written?
echo "> System Preferences > Keyboard > Modifier Keys > Caps Lock Key: Escape"
  # https://apple.stackexchange.com/questions/13598/updating-modifier-key-mappings-through-defaults-command-tool
  # https://apple.stackexchange.com/questions/4813/changing-modifier-keys-from-the-command-line
echo "> System Preferences > Displays > Display > Resolution: Scaled: More Space (Looks like 1680 x 1050)"
  # https://apple.stackexchange.com/questions/376448/how-can-i-set-a-scaled-display-resolution-from-the-command-line-in-macos-catalin
  # https://apple.stackexchange.com/questions/173866/how-can-i-set-the-display-settings-using-command-line
echo "> System Preferences > Dock & Menu Bar > Battery > Show Percentage"
echo "> Finder Preferences > Sidebar > remove: AirDrop; add: home, Screenshots, Hard disks"
# TODO System Preferences > Keyboard > Keyboard > Press fn/globe to "Show Emoji & Symbols"


# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Screenshot > Options > Save to
defaults write com.apple.screencapture "location" -string "~/Screenshots" # && killall SystemUIServer

# System Preferences > General > Appearance
defaults write -globalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# System Preferences > General > Click in the scrollbar to: Jump to the spot that's clicked
defaults write -globalDomain AppleScrollerPagingBehavior -bool true

# System Preferences > General > Close windows when quitting an app
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool true

# System Preferences > Dock > Size:
defaults write com.apple.dock tilesize -int 36

# System Preferences > Dock > Minimize windows using: Scale effect
defaults write com.apple.dock mineffect -string "scale"

# System Preferences > Dock > Automatically hide and show the Dock:
defaults write com.apple.dock autohide -bool true

# System Preferences > Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -float 0.1

# System Preferences > Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -float 0

# System Preferences > Dock & Menu Bar > Bluetooth
defaults write com.apple.controlcenter 'NSStatusItem Visible Bluetooth' -bool true

# System Preferences > Dock & Menu Bar > Spotlight
defaults write com.apple.controlcenter 'NSStatusItem Visible Item-0' -bool false

# System Preferences > Dock & Menu Bar > Siri
defaults write com.apple.siri StatusMenuVisible -bool false

# System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false # makes it more predictable

# System Preferences > Mission Control > Hot Corners > top left: Mission Control, bottom left: Launchpad
# Possible values (modifier = option):
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 3 # TODO check if this works at the same time, before reboot it did not
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-bl-modifier -int 0

# System Preferences > Keyboard > Keyboard > Key Repeat (Fast = 2) / Delay Until Repat (Short = 15)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# System Preferences > Keyboard > Text > Correct spelling automatically
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# System Preferences > Keyboard > Text > Capitalise words automatically
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# System Preferences > Keyboard > Text > Use smart quotes and dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# System Preferences > Keyboard > Shortcuts > Use keyboard navigation to move focus between controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# System Preferences > Trackpad > Point & Click > Tap to click (for this user and the login screen) # TODO did not work
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# System Preferences > Trackpad > Point & Click > Click: Light # TODO did not work
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad FirstClickThreshold -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad SecondClickThreshold -int 0

# System Preferences > Trackpad > Point & Click > Tracking speed++ # TODO did not work
defaults write .GlobalPreferences com.apple.trackpad.scaling -float 0.875

# System Preferences > Trackpad > Scroll & Zoom > Scroll direction: Natural
defaults write .GlobalPreferences com.apple.swipescrolldirection -bool false 

# System Preferences > Trackpad > More Gestures > App Exposé
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder > Preferences > Advanced > Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder > Preferences > Advanced > Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > Preferences > Advanced > Show warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Finder > Preferences > Advanced > When performing a search, Search the Current Folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder > Preferences > Advanced > Keep folders on top: In windows when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Prevent Time Machine from prompting to use newly connected storage as backup volumes.
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true" 


# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1 # TODO check after reboot

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true


# Activity Monitor
# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# iterm TODO jumping to marks only worked with the stock config after installing shell integration
# Specify the preferences directory
# defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
# defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# https://github.com/VSCodeVim/Vim/#mac enable key-repeating in normal mode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false


# Kill affected apps
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

# Done
echo "Done. Note that some of these changes require a logout/restart to take effect."