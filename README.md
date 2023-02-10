# dotfiles

![Screenshot 2022-09-16 at 00 55 08](https://user-images.githubusercontent.com/493741/190522650-8db76278-8e36-445d-9ba3-4fc699a14683.png)

`./setup.sh` will install and configure the software I use. The core setup for terminal/ssh is the same for macOS and Linux.

- System packages
  - macOS: [brew.sh](https://github.com/vogler/dotfiles/blob/master/install/macos/brew.sh)
  - Debian/Ubuntu etc.: [apt.sh](https://github.com/vogler/dotfiles/blob/master/install/apt.sh)
  - npm, pip etc.
  - Windows: [setup.bat](https://github.com/vogler/dotfiles/blob/master/setup.bat) - not really automated; [todo](https://www.slant.co/topics/1843/~windows-package-managers): scoop, Ninite?
- macOS
  - System Preferences and app settings: [defaults.sh](https://github.com/vogler/dotfiles/blob/master/install/macos/defaults.sh)
  - Apps in Dock: [dock.sh](https://github.com/vogler/dotfiles/blob/master/install/macos/dock.sh)
- dotfile manager - not needed, just use `ln -sf` - see below for links
- zsh - shell
  - [prezto](https://github.com/sorin-ionescu/prezto) - configuration framework with sane defaults, aliases, functions... - [zshrc](https://github.com/vogler/prezto/blob/master/runcoms/zshrc)
  - [powerlevel10k](https://github.com/romkatv/powerlevel10k) - prompt - [.p10k.zsh](https://github.com/vogler/dotfiles/blob/master/.p10k.zsh)
  - [fzf](https://github.com/junegunn/fzf) - fuzzy finder: ** for completion, ctrl-t for files, alt-c for cd, ctrl-r for history
- [Neovim](https://neovim.io/) - editor - [.vimrc](https://github.com/vogler/dotfiles/blob/master/.vimrc)
- [.tmux.conf](https://github.com/vogler/dotfiles/blob/master/.tmux.conf) - mostly for ssh, iTerm on macOS

<details>
  <summary>Click to show extracted vim plugins</summary>

  - https://github.com/tpope/vim-sensible - Defaults everyone can agree on
  - https://github.com/tpope/vim-fugitive - provides :G (:Git), :GMove, :GBrowse etc.
  - https://github.com/tpope/vim-rhubarb - GitHub extension for fugitive.vim: :GBrowse, omni-complete issues etc. in commit messages
  - https://github.com/tpope/vim-endwise - end certain structures (if, do, etc.) automatically
  - https://github.com/tpope/vim-surround - add/change/delete surrounding parentheses, brackets, quotes, XML tags
  - https://github.com/tpope/vim-repeat - make . also repeat plugin maps instead of just native commands
  - https://github.com/tpope/vim-eunuch - UNIX shell commands :Delete, :Move, :SudoWrite etc.
  - https://github.com/tpope/vim-unimpaired - Pairs of handy bracket mappings
  - https://github.com/tpope/vim-rsi - Readline key bindings in insert mode
  - https://github.com/tpope/vim-obsession - cont. updated session files; :Obsess starts recording, load with -S or :source
  - https://github.com/tpope/vim-vinegar - file browser enhancements (- opens netrw), - goes up one directory but keeps file focused (enter to go back)
  - https://github.com/tpope/vim-speeddating - increment (C-A) / decrement (C-X) for date/time formats
  - https://github.com/tpope/vim-jdaddy - JSON text objects (aj, ij) and pretty printing (gqaj)
  - https://github.com/tpope/vim-dispatch - Asynchronous build and test dispatcher :Make
  - https://github.com/tpope/vim-dadbod - interface for many databases :DB postgresql:///foobar, :DB sqlite:myfile.sqlite3 select count(*) from widgets
  - https://github.com/tomtom/tcomment_vim
  - https://github.com/scrooloose/nerdtree
  - https://github.com/Xuyuanp/nerdtree-git-plugin
  - https://github.com/majutsushi/tagbar - sidebar with outline viewer / ctags of current file
  - https://github.com/kien/ctrlp.vim - Fuzzy file, buffer, mru, tag, etc finder
  - https://github.com/mileszs/ack.vim - ag search results in quickfix window
  - https://github.com/ojroques/vim-oscyank - SSH: also copy to client clipboard
  - https://github.com/google/vim-searchindex - display number of search matches & index of a current match
  - https://github.com/flazz/vim-colorschemes - colorscheme pack including solarized
  - https://github.com/altercation/vim-colors-solarized - :colorscheme solarized (overwrites the above?)
  - https://github.com/mhinz/vim-startify - start screen (if opened without arg) instead of empty buffer with MRU, bookmarks, sessions
  - https://github.com/simnalamburt/vim-mundo - undo tree visualizer, fork of Gundo, :MundoToggle TODO init error: A supported python version was not found.
  - https://github.com/junegunn/vim-peekaboo - shows contents of registers on the right in sidebar on \" and @ in normal mode and C-r in insert mode
  - https://github.com/junegunn/goyo.vim' - distraction-free writing
  - https://github.com/junegunn/limelight.vim' - only do syntax highlighting for current paragraph
  - https://github.com/junegunn/rainbow_parentheses.vim' - same color for same bracket pairs
  - https://github.com/junegunn/gv.vim' - :GV opens git commit browser, :GV! only commits for current file, :GV? fills location list the revisions of current file, can be used in visual mode to work on just lines
  - https://github.com/vim-airline/vim-airline - status line with multiple sections and support for many plugins
  - https://github.com/vim-airline/vim-airline-themes - :AirlineTheme solarized
  - https://github.com/airblade/vim-gitgutter - git diff markers in sign column; jump to next hunk with ]c, stage hunk with ,hs, undo with ,hu
  - https://github.com/chaoren/vim-wordmotion - more useful word motions incl. camel case, upper/lowercase, hex, numbers etc.
  - https://github.com/unblevable/quick-scope - highlight unique character to find in each word
  - https://github.com/Lokaltog/vim-easymotion - highlights targets to jump to, e.g. ,,w forward word, ,,j down line
  - https://github.com/matze/vim-move - A-k/A-j move line/selection up/down; A-h/A-l move char/selection left/right
  - https://github.com/wellle/targets.vim - text objects for pair, quote, separator, argument, tag
  - https://github.com/michaeljsmith/vim-indent-object - text object for LOC at the same indent level: ii (inner indentation level), ai (incl. line above), iI, aI; e.g. vii
  - https://github.com/vim-scripts/DeleteTrailingWhitespace - :DeleteTrailingWhitespace
  - https://github.com/machakann/vim-swap - swap delimited items; g< left, g> right, gs interactive (h, l, j, k, 1-9, g/G group/ungroup, s sort, r reverse)
  - https://github.com/mg979/vim-visual-multi - multiple cursors; add word with C-n, n/N next/prev, [/] select cursor, q skip, Q remove, tab to switch cursor (normal) and extend (visual) mode
  - https://github.com/wakatime/vim-wakatime - automatic time tracking and metrics, wakatime.com
  - https://github.com/junegunn/vim-easy-align - ga EasyAlign, vipga= (visual inner paragraph align around =), gaii2& (align around 2nd & on inner indentation level)
  - https://github.com/chrisbra/csv.vim - CSV editor, :CSVSort, :MoveColumn
  - https://github.com/gabrielelana/vim-markdown - syntax highlighting for GitHub Markdown flavor
  - https://github.com/SidOfc/mkdx - functions for lists, checkboxes, code, shortcuts, headers, links
  - https://github.com/iamcco/markdown-preview.nvim' - :MarkdownPreview opens in browser with synchronized scrolling - at some point did not open anything anymore, using `yarn install` instead of the above fixed it - https://github.com/iamcco/markdown-preview.nvim/issues/188
  - https://github.com/lervag/vimtex - tex
  - https://github.com/kchmck/vim-coffee-script - coffee
  - https://github.com/leafgarland/typescript-vim - syntax files
  - https://github.com/Quramy/tsuquyomi - client for TSServer: Completion, Navigate, etc.
  - https://github.com/idris-hackers/idris-vim - idris
  - https://github.com/FStarLang/VimFStar - fstar
  - https://github.com/lambdatoast/elm.vim - elm
</details>

### Used Hardware

- macOS: MBA M1, MBP Intel
- Debian: Asus C434 Chromebook, RPi4, RPi3
- Ubuntu: some servers
- Windows 10: desktop PC, setup not automated

## Benchmark / Profiling

### zsh

See [zsh-bench](https://github.com/romkatv/zsh-bench) for details and its [table](https://github.com/romkatv/zsh-bench/blob/master/doc/linux-desktop.md) with results for different configs.

```console
$ git clone https://github.com/romkatv/zsh-bench ~/zsh-bench
$ ~/zsh-bench/zsh-bench
  ==> benchmarking login shell of user voglerr ...
  creates_tty=0
  has_compsys=1
  has_syntax_highlighting=1
  has_autosuggestions=1
  has_git_prompt=0
  first_prompt_lag_ms=28.856
  first_command_lag_ms=311.178
  command_lag_ms=13.115
  input_lag_ms=10.574
  exit_time_ms=87.635
```

### vim

Profile nvim/vim with `v --startuptime v.log; tail v.log` (currently ~190ms).

## Not needed
### dotfile manager

- https://github.com/twpayne/chezmoi
- https://github.com/anishathalye/dotbot
- https://github.com/TheLocehiliosan/yadm
- https://github.com/thoughtbot/rcm
- https://github.com/technicalpickles/homesick
- https://www.gnu.org/software/stow/
