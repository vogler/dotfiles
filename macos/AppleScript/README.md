# Record actions
1. Use Automator to record UI Events which will result in list of Events in a 'Watch Me Do' box.
2. `cmd+a` to select all events and `cmd+c` to copy.
3. `cmd+v` to paste as Apple Script into any editor or Script Editor to modify and run the code.

# Run script
## Terminal
`osascript "iTerm save content as rtf.applescript"`

## As Service with keyboard shortcut
https://apple.stackexchange.com/questions/175215/how-do-i-assign-a-keyboard-shortcut-to-an-applescript-i-wrote

1. Open Automator.
2. Make a new Quick Action.
3. Make sure it receives 'no input' at all programs.
4. Select Run Apple Script and type in your code.
5. Save!

Now go to System Preferences > Keyboard > Shortcuts. Select Services from the sidebar and find your service. Add a shortcut by double clicking (none).

Finally go to System Preferences > Security > Privacy > Accessibility and add Automator and the preferred app to run the shortcut.
