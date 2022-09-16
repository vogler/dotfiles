## Key Bindings
### Repeat last command in last pane

- iterm (`cmd-j`):
  - manually usually did: cmd-[, ctrl-p, ctrl-o, cmd-]
  - Preferences > Keys > Key Bindings > + > Action: Sequence on cmd-j:
    - Next Pane
    - Send Text with "vim" Special Chars
      - `\u001b[A\u000d` (arrow up, enter, [ref](https://apple.stackexchange.com/questions/389700/how-to-send-an-arrow-key-in-iterm2))
    - Previous Pane
    - Swap with Next Pane - somehow needed since Next Pane alone already swaps panes (but only if in Action Sequence -> bug)
- [vscode](https://github.com/vogler/dotfiles/blob/b96f9ed86c6859386596be7412d848f035fddb60/macos/Library/Application%20Support/Code/User/keybindings.json#L81-L82) (`cmd-;`): `!!` TAB LF
- [tmux](https://github.com/vogler/dotfiles/blob/b96f9ed86c6859386596be7412d848f035fddb60/.tmux.conf#L38) (`ctrl-i`): `bind C-i send-keys -t ! C-p C-j`
