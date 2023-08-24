# https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh
# https://macos-defaults.com
# https://mths.be/macos (goes to https://github.com/mathiasbynens/dotfiles/blob/main/.macos)
# https://github.com/herrbischoff/awesome-macos-command-line

echo "The following settings have to be changed manually:" # TODO set some of these somehow? `defaults -currentHost read -g` shows changes to be written?
echo "> System Preferences > Keyboard > Modifier Keys > Caps Lock Key: Escape"
  # https://apple.stackexchange.com/questions/13598/updating-modifier-key-mappings-through-defaults-command-tool
  # https://apple.stackexchange.com/questions/4813/changing-modifier-keys-from-the-command-line
echo "> System Preferences > Displays > Display > Resolution: Scaled: More Space (Looks like 1680 x 1050); Default/native for 4K 32\""
  # https://apple.stackexchange.com/questions/376448/how-can-i-set-a-scaled-display-resolution-from-the-command-line-in-macos-catalin
  # https://apple.stackexchange.com/questions/173866/how-can-i-set-the-display-settings-using-command-line
echo "> System Preferences > Dock & Menu Bar > Battery > Show Percentage"
echo "> System Preferences > Security & Privacy > General > Require password after sleep or screen saver begins: disable for when at home"
echo "> System Preferences > Bluetooth > Advanced > disable Allow Bluetooth devices to wake this computer" # otherwise Bose QC35 turn on MBA if I want to use them on the phone... TODO: Advanced button is just gone after update to macOS Monterey and it wakes up again when I turn on my headphones :(
echo "> Notification Center widgets > size medium for Calendar, size large for Weather, Screen Time Daily Activity, Stocks Watchlist"
echo "> Finder Preferences > Sidebar > remove: AirDrop; add: home, Screenshots, Hard disks"
# TODO System Preferences > Keyboard > Keyboard > Press fn/globe to "Show Emoji & Symbols"
echo "> Chrome Preferences > Page zoom: 110%"


# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Screenshot > Options > Save to
defaults write com.apple.screencapture "location" -string "~/Screenshots" # && killall SystemUIServer
# Also append hostname/MBA/MBP? https://github.com/herrbischoff/awesome-macos-command-line#set-default-screenshot-name

# System Preferences > General > Appearance: Auto
defaults write -globalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# System Preferences > General > Click in the scrollbar to: Jump to the spot that's clicked
defaults write -globalDomain AppleScrollerPagingBehavior -bool true

# System Preferences > General > Close windows when quitting an app
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true # com.apple.systempreferences like on https://mths.be/macos did not work

# System Preferences > Dock > Size
defaults write com.apple.dock tilesize -int 36

# System Preferences > Dock > Minimize windows using: Scale effect
defaults write com.apple.dock mineffect -string "scale"

# System Preferences > Dock > Automatically hide and show the Dock:
defaults write com.apple.dock autohide -bool true

# System Preferences > Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -float 0.1

# System Preferences > Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -float 0

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

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
defaults write com.apple.dock wvous-tl-modifier -int 0 # Tried to set this to 3 to 'show application windows' if option key is held (and Mission Control if not), but after connecting ext. display it did not work anymore (still showed 'Mission Control' in 'Hot Corners'). Reset it and `defaults read` diff then showed 0 - so it seems like it's either or.
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-bl-modifier -int 0

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1 # TODO check after reboot

# System Preferences > Sound > Sound Effects > Play sound on startup
sudo nvram SystemAudioVolume=" " # no diff in defaults. 'Disable the sound effects on boot' from https://mths.be/macos

# System Preferences > Sound > Sound Effects > Play user interface sound effects
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -bool false

# System Preferences > Keyboard > Keyboard > Key Repeat (Fast = 2 (30ms)) / Delay Until Repat (Short = 15 (225ms))
# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
# May need to redo this after system updates!
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# System Preferences > Keyboard > Text > Correct spelling automatically
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# System Preferences > Keyboard > Text > Capitalise words automatically
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# System Preferences > Keyboard > Text > Add full stop with double-space (annoying in vscode)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# System Preferences > Keyboard > Text > Use smart quotes and dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# System Preferences > Keyboard > Shortcuts > Use keyboard navigation to move focus between controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# System Preferences > Keyboard > Shortcuts > Input Sources > disable Select the previous input source (using `bindkey '^ ' autosuggest-execute` in .zshrc, also the alternative ctrl+alt+space is immediate without UI for switching to the next input source)
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# System Preferences > Keyboard > Shortcuts > App Shortcuts (All Applications)
# ctrl-alt-cmd- left, right, o, m
defaults write -g NSUserKeyEquivalents '{
    "Move Window to Left Side of Screen" = "@~^\U2190";
    "Move Window to Right Side of Screen" = "@~^\U2192";
    "Move to Built-in Retina Display" = "@~^o";
    "Move to DELL UP3216Q" = "@~^o";
    Zoom = "@~^m";
}'

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

# Finder > Preferences > General > New Finder windows show:
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget PfHm

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

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Prevent Time Machine from prompting to use newly connected storage as backup volumes.
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"

# Disable local Time Machine backups while the Time Machine backup volume is not available
# hash tmutil &> /dev/null && sudo tmutil disablelocal # disablelocal: Unrecognized verb. Can't be disabled anymore: https://github.com/herrbischoff/awesome-macos-command-line#local-backups

# Activity Monitor > View > Dock Icon > Show CPU History
defaults write com.apple.ActivityMonitor IconType -int 6

# Activity Monitor > View > All Processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Activity Monitor > CPU tab: Sort by % CPU
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Terminal Preferences > Profiles > Add Solarized Light & Dark
# first tried the official files (both ansi and xterm-256color) in https://github.com/altercation/solarized/tree/master/osx-terminal.app-colors-solarized, but the colors were not set correctly such that vim was unreadable (also had some background transparency)
# work fine: https://github.com/tomislav/osx-terminal.app-colors-solarized
curl -L https://raw.githubusercontent.com/tomislav/osx-terminal.app-colors-solarized/master/Solarized%20Light.terminal -o /tmp/SolarizedLight.terminal
open /tmp/SolarizedLight.terminal # will open a new terminal
rm -f /tmp/SolarizedLight.terminal
curl -L https://raw.githubusercontent.com/tomislav/osx-terminal.app-colors-solarized/master/Solarized%20Dark.terminal -o /tmp/SolarizedDark.terminal
open /tmp/SolarizedDark.terminal # will open a new terminal
rm -f /tmp/SolarizedDark.terminal
defaults write com.apple.Terminal 'Default Window Settings' -string SolarizedDark
defaults write com.apple.Terminal 'Startup Window Settings' -string SolarizedDark
# ^ alternatively use osascript to change default profile: https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.macos#L628
# nested dicts can't be easily set with defaults, https://superuser.com/questions/486630/reading-values-from-plist-nested-dictionaries-in-shell-script
# no need for Save command in this direct/non-interactive mode
# Set fails if key does not exist, Add fails if it does. UseBoldFonts already exists in the XML file.
/usr/libexec/PlistBuddy -c "Set :'Window Settings':SolarizedLight:UseBoldFonts true" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Set :'Window Settings':SolarizedDark:UseBoldFonts true" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Add :'Window Settings':SolarizedLight:useOptionAsMetaKey bool true" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Add :'Window Settings':SolarizedDark:useOptionAsMetaKey bool true" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Add :'Window Settings':SolarizedLight:Bell bool false" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Add :'Window Settings':SolarizedDark:Bell bool false" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Add :'Window Settings':SolarizedLight:VisualBellOnlyWhenMuted bool false" ~/Library/Preferences/com.apple.Terminal.plist
/usr/libexec/PlistBuddy -c "Add :'Window Settings':SolarizedDark:VisualBellOnlyWhenMuted bool false" ~/Library/Preferences/com.apple.Terminal.plist
# TODO set font from Monaco 11 to Menlo 14 (stock) or DejaVu Sans Mono for Powerline 14 (brew). Font seems to be set as bytes. See `defaults read com.apple.Terminal`.

# iterm TODO jumping to marks only worked with the stock config after installing shell integration
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/macos/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# https://github.com/VSCodeVim/Vim/#mac enable key-repeating in normal mode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Skim: auto reload by default instead of asking in dialog
defaults write -app Skim SKAutoReloadFileUpdate -boolean true

# Kill affected apps
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

# Done
echo "Done. Note that some of these changes require a logout/restart to take effect."
