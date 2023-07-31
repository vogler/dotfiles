# run with cmd-alt-shift-c via iTerm2 > Services - see README.md
tell application "System Events" to tell application process "iTerm2"
	set frontmost to true
	click menu item "Save Contents…" of menu 1 of menu bar item "Shell" of menu bar 1
	tell sheet 1 of window 1
		click pop up button 2
		click menu item "Rich text (RTF)" of menu 1 of pop up button 2
		click UI element "Save"
	end tell
	click UI element "Use .rtf" of window 1
end tell
