# We could generate a Brewfile with `brew bundle dump` (even with cask & mas), but would lose format/comments every run.
# So we just use a shell script to install each package. Also, sometimes there's some post-install linking to be done.

# Show installed pkgs that are not deps of another installed formula or cask: brew leaves
# Show reverse dependencies: brew uses --recursive --installed python@3.9
brew tap martido/homebrew-graph # 232KB, example: `brew graph --installed --highlight-leaves | fdp -T png -o graph.png`, see https://blog.jpalardy.com/posts/untangling-your-homebrew-dependencies/

# $HOMEBREW_PREFIX changed from /usr/local on Intel to /opt/homebrew on ARM
# Some opam packages don't consider this yet, so we link it back on ARM (share is not needed for opam but for zsh completions to load):
[[ $(uname -m) == "arm64" ]] && sudo ln -sfn /opt/homebrew/{include,lib,share} /usr/local/

# Intel (Activity Montior > Kind) means it runs with Rosetta which is a bit slower and results in more memory pressure

# package managers first which may be used below
brew install pipx # 1MB, like npx: run/install binaries from Python packages, easier than `python3 -m venv foo`; `pipx run lastversion` saves to '~/Library/Caches/pipx', `pipx install lastversion` saves to '~/Library/Application Support/pipx'...
brew install uv # 36M, Rust, fast Python package installer and resolver, `uv tool install lastversion`, `uvx lastversion`, replaces most other Python tools incl. Poetry, `uvx` -> `.cache/uv`, `uv tool install` -> `.local/{bin,share/uv/tools}` (2025-02-03T14:37:51+01:00)
brew install dra # 3.1M, Rust, Command-line tool to download release assets from GitHub (2025-01-29T18:08:42+01:00). Alternative to https://github.com/dvershinin/lastversion `uv tool install lastversion` in setup.sh; interactive by default, failed for smudge/nightlight while lastversion worked...

# OS tools
# list all apps installed from the App Store: `mdfind kMDItemAppStoreHasReceipt=1`
# list manually installed packages: `pkgutil --pkgs`
brew install mas # CLI for macOS App Store
brew install m-cli # CLI for macOS and stock apps
brew install dockutil # edit Dock (used in dock.sh)
# brew install cheatsheet # hold cmd key to show overlay with all shortcuts of current application
# brew install shortery # 6.9MB, triggers for Shortcuts, tried Sleep/Wake Up to log to file, but did not work
# brew install sound-control # 23MB, 14d trial, allows to lower volume of speakers connected to display via HDMI/DisplayPort (macOS can't, so volume would need to be changed on speakers (no problem on Windows)) - sometimes made videos hang on sound until clicked on menu icon
brew install eqmac # 77MB, Swift, Audio Equalizer & Volume Mixer, needs to install audio driver and creates new audio device, but currently only way to (keyboard-)control volume on speakers (via display via HDMI)
brew install MonitorControl # 42MB, Swift, simple app to control external monitor brightness & volume, also with keyboard - brightness works great, but volume via HDMI doesn't work on M1: https://github.com/MonitorControl/MonitorControl/issues/323#issuecomment-919882176 - could try DisplayPort
brew install betterdisplay # 22MB, 14d trial, display management with many more options, but volume also doesn't work
brew install karabiner-elements # 29MB, modify keyboard/mouse input, mostly use capslock mappings from https://github.com/Vonng/Capslock
brew install alt-tab # 26MB, Swift, alt-tab like on Windows, with previews, Raycast's 'Switch Windows' has search but can't just alt-tab to switch between recent windows

# Quick Look extensions - https://github.com/sindresorhus/quick-look-plugins, more: https://github.com/haokaiyang/Mac-QuickLook
brew install qlvideo # <1MB, Apple doc says quicklook generators are only called upon demand (so no overhead for mds?); deprecated: qlimagesize
# brew install quicklook-json # can click to fold json, but light theme not as nice as json printed by syntax-highlight, also slower; folding in quickjson didn't work at all
# The following install to /Applications and need to be opened once for their quick look extension to register.
# brew install glance # discontinued; need to open Glance.app first; replaces qlcolorcode qlmarkdown quicklook-json
brew install --no-quarantine syntax-highlight # 39MB, syntax highlighting for most source code files (just .ts not allowed by macOS), replaces qlstephen for plain files; changed config: Render engine RTF -> HTML because RTF always used light theme instead of dark, Font MesloLGS NF 16pt, Soft wrap, Line numbers, Window size 1000x1200
brew install --no-quarantine qlmarkdown # 76MB, app has many options & extensions for markdown preview, window size 1000x1200, adjust font size via css: https://github.com/sbarex/QLMarkdown/issues/79
xattr -d -r com.apple.quarantine ~/Library/QuickLook # remove plugins from quarantine
qlmanage -r # refresh installed plugins

# Desktop tools
# brew install sizeup # Intel, unlimited trial
# brew install shiftit # Intel, not needed anymore since macOS offers move window to left/right, other display; shortcuts setup by defaults.sh - window management replaced by Raycast
brew install rectangle # 7.6MB, move and resize windows using keyboard shortcuts or snap areas; ctrl-alt-left/right can cycle through 1/2, 2/3, 1/3
# mas install 967805235 # Paste - Clipboard Manager; need subscription now to actually use paste...
brew install hammerspoon # 39MB, automation, window management, key/mouse mapping - see .hammerspoon/init.lua
# brew install usb-overdrive # 2.3MB, shareware, device driver for USB/Bluetooth input (mouse, keyboard, gamepad etc.) to configure globally or on a per-application, per-device basis - messed up left click..., per-application not good enough for Books.app
brew install raycast # 75MB, better launcher than Spotlight, Alfred etc., good shortcuts incl. window management, community extensions/scripts
  # brew install smudge/smudge/nightlight # just downloaded bin (476K) from releases at https://github.com/smudge/nightlight since this tried to build and install rust and its deps, see https://github.com/smudge/nightlight/issues/22
  uvx lastversion --pre --assets unzip smudge/nightlight && chmod +x nightlight && mv -f nightlight ~/.local/bin/
  # `nightlight status` fails with 'zsh: bad CPU type in executable: nightlight' -> works with Rosetta enabled (was disabled again after macOS update)
  # `file` says 'Mach-O 64-bit executable x86_64' instead of 'arm64e'
brew install istat-menus # 68MB, trial, got key, menu bar: HW stats (combined: graph for CPU & memory, rest in dropdown), calendar, weather (subscription for 60min updates)
# brew install stats # 12MB, simple free alternative to istat-menus, just HW, no calendar, weather
brew install leader-key # 5.1M, Application launcher with nice UI/json for config with groups, e.g. <leader>rc for raycast://confetti, but can only set leader to a normal key combination, so would need Karabiner to map one key to that combination (2025-02-03T14:13:15+01:00)

# ~/Screenshots
# usually (ctrl+)cmd+shift+3/4/5 is enough, but even after disabling 'Show Floating Thumbnail' it still takes a couple of seconds for the file to show up which is annoying; also, it can't do scrolling screenshots (Chrome can via DevTools or GoFullPage extension, but sometimes I need it for other windows as well)
# both shottr and cleanshot can only do scrolling screenshot for area instead of window/app (like on Windows and Android), maybe that's a macOS restriction
brew install shottr # 6.0M, 12$, 30d free, then popups, not a replacement since can't adjust filename (SCR-20250522-qami.png -> no time, but random letters), QuickLook opens its screenshots at ~50% size despite files being slightly bigger; good: editor for annotations (arrows, blur etc.), OCR to clipboard, can save jpg if better fit than png (2025-05-22T17:54:29+02:00)
# brew install cleanshot # 59M, $34.51, can't try without buying a license, looks similar to shottr but also has video editor/keystrokes/camera, custom filename incl. app/window title, TODO try (2025-05-22T18:31:13+02:00)

# HW tools
# brew install tg-pro # trial
# brew install logi-options+ # 460MB, software for Logitech mouse M350s (Pebble 2); scroll speed 100%, pointer speed 80%; RAM: logioptionsplus_agent (46MB), logioptionsplus_updater (7MB)
# brew install logitech-g-hub # software for G305 - not used since configured on Windows and stored on mouse
brew install bettermouse # 13M, adjust smooth scroll with curve, accel, DPI, custom buttons, fixes left click-through (by default per control, e.g. Chrome would register click on 'new tab' in unfocused window (also middle click, scroll), but require two clicks for button on webpage), exceptions etc., replaces logi-options+ (2025-05-18T19:54:45+02:00)

# browser/-based apps
brew install google-chrome # 922MB
brew install chrome-cli # 125KB, control chrome via scripting bridge, `OUTPUT_FORMAT=json chrome-cli list tabs`
brew install firefox # 344MB, don't really use it, but good to have options
brew install zen # 430M, Arc-like Firefox, open-source, customizable (2025-03-03T23:03:19+01:00)
brew install spotify # 298MB, was Intel but now Apple Electron (or similar) -> use Chrome App: same (except no recently played and friends feed, diff. shortcuts) and can share resources with Chrome (19MB vs 476MB RSS)
brew install whatsapp # 330MB, now Apple Silicon and no longer Intel, can do calls, has cmd+shift+[] for switching chats, but UI slightly different from web app and needs more memory.
# Alternative: WhatsApp Chrome App. Needs less memory, but can't do calls and no good shortcuts. Provided by Chrome account sync. To add to your account visit web.whatsapp.com, dot-menu > More Tools > Create Shortcut with open as window
brew install slack # 238MB
brew install microsoft-teams # 507MB, only needed for stupid background image since browser version does not offer it (but this is also browser-based)...
# brew install evernote # Intel; not worth the overhead, just use the web-app and eventually something nicer with history
brew install tor-browser # 192MB
brew install obsidian # 412MB, PKM, just keeps folders of .md files, nice markdown editor, sometimes slow/annoying (Electron), not perfect, but at least customizable with lots of community plugins (core not OSS)

# vscode and forks focused on AI features
brew install visual-studio-code # 370MB, `code .`
brew install cursor # 436M, has best tab-complete for small AI-based edits and jumping, available in free plan again (2025-05-22T19:03:43+02:00)
brew install trae # 555M, works but no cursor-like tab, inline was hit and miss (2025-05-21T16:13:34+02:00)
brew install windsurf # 549M, haven't really tried (2025-05-22T19:07:22+02:00)
# brew install void # 432M, open source, can add API keys with free quota for Gemini and OpenRouter -> quota was used up right away, looks like just vscode (2025-05-21T16:15:33+02:00)
  # just use vscode extension? https://github.com/RooCodeInc/Roo-Code

# other desktop apps
brew install dropbox # only 9GB with free plan, moved Screenshots <2021 to PC TODO replace with self-hosted alternative on RPi
brew install tresorit # 225MB, encrypted cloud storage for TDD
brew install telegram # 152MB, 96MB RAM, Swift, narrow: chats>chat
brew install telegram-desktop # 216MB, 340MB RAM, C++ webkit?, chats on side, can export chat data (settings > advanced)
brew install zoom # 98MB, some meetings can't be done in the browser?
# brew install coscreen # 662MB, multi-user interactive screen sharing for pair programming
brew install libreoffice
# mas install 1030461463 # PDFCombo: merge PDFs and preserve the TOC
# brew install pdf-expert # 200MB, more features than Preview.app: annotations, edit text, merge, crop, clear, margins, OCR, better reduce file size export. Free version useless and full version 140€ or 80€/year.
# https://outbankapp.com neither in brew nor mas (but finds outbank in App Store)
brew install iina # 145MB, media player, nicer than VLC
brew install vlc # 134MB, media player, only needed for .m3u streaming of DVB-C TV from FritzBox
# mas install 1612400976 # 89MB, media player, installed as /Applications/PotPlayerX.app, can generate poster, gif, subtitles via whisper, do OCR, PIP, but some features like changing speed with shortcuts require VIP..., also can't play .m3u for DVB-C TV from FritzBox
brew install raspberry-pi-imager # install different OSes to microSD
brew install numi # 49MB, calculator app with unit conversions and variables
brew install portfolioperformance # 168MB, Internal and True-Time Weighted Rate of Return, graphs etc., can import PDFs of transactions from ING, but needs manual work; probably works for degiro as well
brew install --cask r # 95MB, Environment for statistical computing and graphics; https://www.coursera.org/learn/practical-time-series-analysis

# Android
brew install android-platform-tools # 30MB, adb etc., `adb shell/push/pull`
brew install android-file-transfer # 6.71MB, simple default app for MTP file transfer by Google, can copy/delete
# brew install macdroid # 45.39MB, can also mount as disk (and via ADB besides MTP), but read-only in free version...
# brew install openmtp # 395MB, same as android-file-transfer, just other UI
brew install android-studio # 2.8G, Tools for building Android applications (2025-05-29T18:08:53+02:00) need Android emulator for HTTP-Toolkit or rooted device
brew install jadx # 122M, Dex to Java decompiler (2025-06-05T16:41:45+02:00)
brew install apktool # 24M, Tool for reverse engineering 3rd party, closed, binary Android apps (2025-06-05T16:42:09+02:00)

# Terminal Spotify client
brew install ncspot # 12MB, Rust, can just login, nice UI and shortcuts but had some issues with displaying progress bar and doesn't scrobble to Last.fm, fills up ~/.cache/ncspot/librespot
# brew install spotify-tui # 12MB, Rust, `spt`, just uses Web API to control other devices/clients (need to create app for Client ID/secret) or play using spotifyd (requires dbus)
brew install spotify_player # 26MB, Rust, most features, everything works, can just login, scrobbles to Last.fm, even shows album art und lyrics, doesn't fill up cache

# Terminal markdown viewers
brew install glow # 17M, Go, Render markdown on the CLI (2025-05-24T20:27:09+02:00) `glow -a` to select local md files with edit date, `glow -p foo.md` to open a single file with pager, `glow github.com/charmbracelet/glow` to fetch README from GitHub/GitLab
# `uv tool run frogmouth` Python TUI with mouse support, contents, bookmarks, history
# more: https://www.adamsdesk.com/posts/linux-markdown-viewers/

# Terminal browser
# brew install lynx # 2.3M, Text-based web browser (2025-06-08T22:02:15+02:00)
brew install links # 1.8M, Lynx-like WWW browser that supports tables, menus, etc. (2025-06-08T22:02:27+02:00)
brew install w3m # 2.0M, Pager/text based browser (2025-06-08T22:02:34+02:00)

# games
brew install openra # 136MB, open source Command & Conquer Red Alert, Tiberian Dawn, Dune 2000
brew install steam # 6.7M + ~1.2GB in ~/Library/Application\ Support/Steam (games in ./steamapps/common), requires Rosetta, only used for Factorio (2024-10-21)

# editors
brew install neovim # editor, no need for vim, config in .vimrc
brew install vimr # 77MB, VimR.app/`vimr` as GUI with file browser, markdown preview, macOS shortcuts - used for macOS `open`, nicer than neovide, neovim-qt, macvim
brew install vv # 409M, VV.app/`vv` like VimR, but based on Electron, tried since VimR had some error on startup with my old .vimrc, bit slow with big files, but otherwise ok (2025-01-29T21:44:47+01:00)
brew install helix # 135MB, modern vim-like modal editor, mostly similar, but selection -> action model, words selected by default on motion; many things like surround and git-gutter included, but no plugin system yet; see .config/helix/config.toml

# terminals
brew install iterm2 # 78MB, better Terminal.app, https://sourabhbajaj.com/mac-setup/iTerm/
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
brew install warp # 147MB, fast rust-based terminal, bit more modern than iterm, but pretty similar, TODO colors and font in vim are off
# brew install tabby # 346MB, TS, customizable terminal, SSH and serial client; nice UI, but colors in vim are off, feels slower than iTerm and no additional features I currently need
brew install ghostty # 48M, nice, but pretty minimal features, only restores tabs without contents (2025-03-03T23:28:15+01:00)

# terminal multiplexers
brew install tmux # terminal multiplexer, used for ssh by default via prezto
brew install zellij # 23MB, Rust, like tmux, but more modern, shows keybindings (default binds things like ctrl-p for panes, but can lock with ctrl-g), built-in session restore

# shells
# brew install zsh # no need since macOS /bin/zsh is version 5.9, same as this
brew install fish # 20M, User-friendly command-line shell for UNIX-like operating systems (2025-02-08T15:36:49+01:00) - not really needed with nushell?
brew install nushell # 141M, Rust, Modern shell for the GitHub era (2025-02-08T15:37:34+01:00) start with `nu`, also nice for data processing since it has structured/table output to select/filter/sort, `get` supports JSON, YAML, SQLite etc. - https://www.nushell.sh

# sys tools
brew install coreutils # newer than macOS
brew install moreutils # more tools: ts for prefixing timestamps, parallel, combine, sponge etc.
brew install findutils # GNU find, xargs, and locate - macOS find does not have -iname
brew install gnu-time # gtime has more features than the builtin time command
brew install grep # newer than macOS: 3.6 vs 2.5.1-FreeBSD
brew install gnu-sed # newer than macOS: 4.8 vs 2017 BSD?
brew install sad # 3.7MB, modern sed with preview via fzf and delta: `fd .sh | sad bash zsh` (TAB for multi-select), `... | delta`
brew install less # newer than macOS: 590 vs 487
brew install rsync # newer than macOS: 3.2.3 vs 2.6.9
brew install htop # improved top (interactive process viewer)
# brew install gtop # 11.6MB, System monitoring dashboard for terminal (nodejs) - not interactive and ~10% CPU on RPi3
brew install bottom # 3.2MB, `btm`, Yet another cross-platform graphical process/system monitor (rust) - interactive with mouse and shortcuts
brew install gotop # 11M, Go, inspired by gtop and vtop; sums up and counts processes of same executable (2025-03-19T16:53:17+01:00)
brew install nvtop # 224K, Interactive GPU process monitor, supports Apple (experimental, does not show much), AMD, Nvidia, Intel, Qualcomm, Broadcom... (2025-01-29T17:48:45+01:00)
brew install osquery # 24MB, C++, SQL powered operating system instrumentation and analytics; `osqueryi` to start REPL; .tables; select * from shell_history order by time desc limit 10; https://osquery.io/schema
brew install procs # 3MB, modern replacement for `ps aux | grep ..` in Rust, fields for open ports, throughput, container name; ex: procs --tree nvim; procs --watch
brew install pueue # 11.9MB, Rust, manage sequential/parallel long-running tasks, `pueued`, `pueue add ls; pueue add sleep 100; pueue; pueue log`
brew install pv # 186KB, pipe viewer shows progress, speed, ETA; `pv -cN source < foo | zip | pv -cN zip > foo.zip`
# brew install exa # 1.4MB, Modern replacement for 'ls' - now unmaintained, use eza
brew install eza # 1MB, maintained fork of exa; `eza --long --header --icons --git`
brew install lsd # 1.6MB, `ls` clone with colors, file type icons, `lsd --tree`; looks nicer than exa, but no git status
brew install tree # `exa --tree --level=2` has colors and can show meta-data with --long
# brew install tldr # 105KB, `tldr tar` shorter than `curl cheat.sh/tar` and works offline - deprecated and will be disabled; alternatives: tealdeer, tlrc
# brew install tealdeer # 3.2M, Rust, `tldr`, but didn't like colors and didn't automatically create/update cache w/o creating config (2025-03-04T10:08:39+01:00)
brew install tlrc # 2.2M, Rust, official `tldr` client (2025-03-04T10:09:55+01:00)
brew install bat # cat with syntax highlighting and Git integration
brew install fd # Simple, fast and user-friendly alternative to find
brew install the_silver_searcher # 172KB, ag: Code-search similar to ack, but faster [C]
brew install ripgrep # 5.8MB, rg: Code-search similar to ag, but faster [Rust]
brew install ugrep # 1.2MB, ug: grep with interactive TUI (-Q), fuzzy search, hexdump, search binary, archives, compressed files (-z), documents (PDF, pandoc, office, exif...), output as JSON, CSV...
brew install pdfgrep # `pdfgrep -nH PATTERN *.pdf` as alternative (with page number) to `ug --filter='pdf:pdftotext % -' PATTERN *.pdf`
brew install iozone # 300KB, file system benchmark tool, see https://www.pidramble.com/wiki/benchmarks/microsd-cards
brew install duf # 3.1MB, Go, Disk usage/free, nicer `df`; alternative in Rust: dysk
brew install diskus # 839KB, Rust, minimal, 3-10x faster alternative to `du -sh`
brew install dust # 2.2MB, Rust, prints overview (terminal height) of the biggest folders and their subfolders with percentage bars
brew install ncdu # 588KB, interactive NCurses Disk Usage; archive: `ncdu -o export.json; ncdu -f export.json`
brew install dua-cli # 1.9MB, Rust, `dua` space for all files/folders, `dua *` for non-hidden, `dua i` for interactive mode like ncdu
brew install gdu # 13MB, Go, `gdu-go` (`gdu` is GNU du) for interactive mode like ncdu; used for <space>tu in AstroNvim; alternatives: https://github.com/dundee/gdu#alternatives
ln -sfn /opt/homebrew/bin/gdu-go ~/.local/bin/gdu # overridden by prezto alias for `git ls-files --other --exclude-standard`
brew install disk-drill # 113MB, GUI, disk usage & clean up (filters for type, size, modified), data recovery, find duplicates
# brew install clean-me # 2.5MB, GUI analyze/clean caches, logs, temp files, trash, downloads etc., see https://github.com/Kevin-De-Koninck/Clean-Me/blob/master/Clean%20Me/Paths.swift - integrated in macos/cleanup.sh, deprecated in brew
brew install pearcleaner # 6.7M, Utility to uninstall apps and remove leftover files from old/uninstalled apps (2025-03-04T10:25:12+01:00)
# brew install sensei # 72MB, 14d trial, GUI, system overview, menu bar monitor, optimize, clean, SSD stats/benchmark, battery health
brew install p7zip # 7z with support for Brotli, Fast LZMA2, LZ4, LZ5, Lizard and Zstd
brew install the-unarchiver # unpack .rar
brew install unar # 15MB, The Unarchiver CLI: `unar`, `lsar`
brew install ouch # 3.5MB, Rust, (de)compress/list based on extension (tar, zip, 7z, gz, xz, lzma, bz, bz2, lz4, sz, zst, rar): `ouch d a.zip b.tar.gz`, `ouch c foo bar baz.7z`, `ouch l foo.rar`
brew install watch # Executes a program periodically, showing output fullscreen
brew install watchexec # 5.7MB, Execute commands when watched files change. `watchexec --clear --notify -- ls -lah`, `watchexec -e js,css --restart -- npm start`
brew install mmv # move/copy/append/link multiple files by wildcard patterns
brew install f2 # 11.5MB, Go, batch renaming tool with variables for file metadata like dates, Exif, ID3
# use vidir from moreutils for interactive batch rename in vim
brew install figlet # Banner-like program prints strings as ASCII art
brew install cmatrix # 78KB, console matrix screensaver
brew install gum # 25MB, fancy input for shell scripts: choose a b, input, write, confirm
brew install fzf # 2.7MB, Command-line fuzzy finder written in Go, search shell history with ctrl-r
brew install atuin # 25.4MB, Rust, records shell history in sqlite with cwd, hostname etc., TUI for interactive search on ctrl-r, Enter to execute, Tab to edit first; `atuin import auto` to import from zsh history, integration loaded in zshrc; overrides fzf history binding ctrl-r, also starts on cursor up, but not on ctrl-p
brew install fastfetch # 2.5MB, system information with OS + logo, host, kernel, uptime, packages, shell, displays, terminal, CPU, GPU, memory, swap, disk, IP, battery - neofetch was deprecated
# terminal file managers with vim keybindings, default single column
# brew install fff # 50KB, Bash, simple file manager, f in .zshrc changes dir on exit (q) - deprecated
brew install nnn # 280KB, C, file manager, small and fast, but bare bones without plugins/config, single column but tabs; use `nnn -e` to edit text in same terminal instead of via `open`
brew install ranger # 2.8MB, Python, file manager, slower, but nicer defaults with multi-column layout and automatic preview of many file types
brew install yazi # 7.8MB, Rust, file manager, like ranger, but faster, scrollable preview for images, videos, pdfs etc.
brew install lf # 3.8MB, Go, file manager, like ranger, https://github.com/gokcehan/lf/wiki/Tutorial
brew install xplr # 4.7MB, Rust, file manager, hackable with Lua, nice interactive help, plugins: https://xplr.dev/en/awesome-plugins
brew install zoxide # 1MB, Rust, smarter cd command, inspired by z and autojump
brew install broot # 6.2MB, `br` to navigate big file trees, alt+enter to cd, `br -s` to show sizes
brew install dos2unix # Convert text between DOS, UNIX, and Mac formats; for git's fatal: CRLF would be replaced by LF
brew install choose-rust # 2.0MB, Human-friendly and fast alternative to cut and (sometimes) awk, `choose -f ':' 0 3` prints the 0th and 3rd items sep by :, `choose -3:-1` prints the last 3 items sep by space
brew install tuc # 1MB, Rust, like cut, but can do more than one character, negative index, work on lines and emit as --json
brew install hck # 2.2MB, Rust, drop-in replacement for cut, but supports regex delimiter and reordering columns
brew install clog # 173KB, Colorized pattern-matching log tail utility, https://taskwarrior.org/docs/clog/, `echo 'foo bar' | clog -d -t -f <(echo 'default rule /foo/ --> bold red match')`
brew install grc # 114KB, Colorize logfiles and command output; `\grc ping google.com; \grc tail /var/log/system.log; man grcat`
brew install tailspin # 5.2MB, Rust, automatic log file highligher, supports numbers, dates, IP-addresses, UUIDs, URLs and more; pipe to `tailspin` or `tspin`
brew install spacer # 3.3MB, Rust, insert spacers with datetime+duration when command output stops, default is 1s, `tail -f some.log | spacer --after 5` (only after 5s instead); `log stream --predicate 'process == "Google Chrome"' | spacer`; 'If you're the type of person that habitually presses enter a few times in your log tail to know where the last request ended and the new one begins, this tool is for you!' :)
brew install navi # 2.7MB, Interactive CLI cheatsheet tool; `navi` to start fuzzy finder; `eval "$(navi widget zsh)"` to launch with Ctrl+G to find/replace in-place
brew install yank # 49KB, Copy terminal output to clipboard; `env | yank -d =`, can also be used as picker in pipe: `ps ux | yank -g ' [0-9]+ ' | xargs kill`
brew tap homebrew/command-not-found # 8.56MB, used by command-not-found module in ~/.zpreztorc
brew install zet # 1.5M, CLI utility to find the union, intersection, and set difference of files (2025-03-03T22:49:56+01:00)

# programming languages
# macOS ships ruby 2.6.3, python 2.7.16; python3 installed as dep; typescript via npm
brew install pyenv # 7.6M, Python version management (2025-05-24T10:53:15+02:00) creates virtualenv in ~/Library/Caches/pypoetry/
brew install ptpython # better Python REPL
brew install node # JavaScript; includes npm
# use fnm as node version manager? https://github.com/Schniz/fnm
brew install oven-sh/bun/bun # 54M, alternative to node/deno (both v8; bun uses WebKit), faster, bun replaces npm/pnpm, bigger/nicer stdlib (sqlite, pg, S3, $ like zx, Bun.file, ...) (2025-04-05T20:14:13+02:00)
brew install deno # 117M, Secure runtime for JavaScript and TypeScript (2025-06-08T22:20:02+02:00)
brew install opam # OCaml
brew install java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk # For the system Java wrappers to find this JDK
# brew install cling # C++ REPL based on LLVM and Clang
mkdir -p ~/.local/bin
ln -sfn /Library/Developer/CommandLineTools/usr/bin/clangd ~/.local/bin/ # used for coc-clangd in nvim
brew install dotnet-sdk # 793MB, .NET CLI (2025-04-30T12:06:58+02:00)
  # 793MB = 199MB /opt/homebrew/Caskroom/dotnet-sdk + 594MB /usr/local/share//dotnet + 0 ~/.dotnet + 0 ~/.nuget
  # uninstall anything non-brew first: curl -sSL https://raw.githubusercontent.com/dotnet/sdk/refs/heads/main/scripts/obtain/uninstall/dotnet-uninstall-pkgs.sh | sudo bash
  # cleanup SDKs and runtimes with dotnet/cli-lab: https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool-overview?pivots=os-macos
brew install z3 # 33M, High-performance theorem prover (2025-04-30T22:21:06+02:00)
# brew install dart-sdk # 526M, Dart Language SDK, including the VM, dart2js, core libraries, and more (2025-05-30T15:59:18+02:00)
# brew install flutter # 4.13G, UI toolkit for building applications for mobile, web and desktop (2025-05-30T16:12:49+02:00)

# linters
brew install shellcheck # 68M, Static analysis and lint tool, for (ba)sh scripts (2025-03-05T14:43:21+01:00)
brew install actionlint # 5.0M, Static checker for GitHub Actions workflow files (2025-03-05T14:40:23+01:00)
brew install hadolint # 78MB, Dockerfile linter to validate best practices, can also just use online version to shows warnings inline: https://hadolint.github.io/hadolint/ (2025-03-05T14:44:18+01:00)
brew install typos-cli # 13.6MB, Source code spell checker (en) for many languages (identifiers, comments, filenames), low false positive rate; `typos` to see, `typos -w` to fix
brew install lychee # 23M, Rust, Fast, async, resource-friendly link checker (2025-05-24T12:24:12+02:00)

# dev tools
brew install tokei # count code lines fast and by language
brew install semgrep # semantic grep: lightweight static analysis for many languages
brew install rlwrap # used in ocaml alias since it has no readline support; use utop for better REPL
brew install pkg-config
brew install autoconf automake # autotools
brew install heroku/brew/heroku
# mas install 1388020431 # DevCleaner for Xcode: cleans cache files (none if not actually using Xcode)
brew install devutils # 48MB, demo, GUI with converters for unix time, base64, URLs, regex, JSON, CSV, Markdown etc.
brew install grex # 2.4MB, Command-line tool for generating regular expressions, `grex -c bar baz`
brew install hexyl # 781KB, Command-line hex viewer
brew install binocle # 8.6MB, Rust, GUI tool to visualize binary data
brew install diffoscope # 13MB (12.1MB libmagic), In-depth comparison of files, archives, and directories (2025-01-29T17:33:28+01:00)
brew install hyperfine # 1.5MB, Command-line benchmarking tool, `hyperfine 'sleep 0.3'`, `hyperfine --warmup 3 --parameter-scan delay 0.3 0.7 -D 0.2 'sleep {delay}'`
brew install just # 2.6MB, replacement for make, runs commands from `justfile`, `just -l` to list
brew install meta-package-manager # ~58MB, Wrapper around all package managers with a unifying CLI; `mpm outdated`, `mpm upgrade`, `mpm --all-managers managers`; has apt, brew, cargo, choco, composer, dnf, emerge, flatpak, gem, mas, npm, opkg, pacaur, pacman, paru, pip, pipx, scoop, snap, steamcmd, vscode, yarn, yay, yum, zypper

# containers
brew install --cask docker # 1.5 GB, hate it, only gave in for avoiding captcha with headless playwright
# brew install podman # 55 M + 588 MB deps + 590MB fedora-coreos-qemu = 1.23 GB, daemon-less alternative to docker, but only runs QEMU-VMs on macOS which takes time to boot -> not interesting on macOS
brew install orbstack # 770MB, faster drop-in replacement for Docker Desktop, `orb`, https://orbstack.dev
brew install lazydocker # 16MB, Go, TUI to manage containers, images, volumes and networks
brew install dive # 10MB, explore layers in docker images
brew install ctop # 8.9MB, Top-like interface for container metrics
brew install act # 22MB, Run your GitHub Actions locally

# git
brew install git # 57.7MB, Apple Git is only updated together with Xcode and some versions behind
# brew install diff-so-fancy # within-line highlights
# https://terminaltrove.com/categories/diff/
brew install git-delta # as diff-so-fancy but with language syntax highlighting, side-by-side, etc.; https://dandavison.github.io/delta/related-projects.html
brew install dlvhdr/formulae/diffnav # 31M, diff pager based on delta but with a file tree (2025-01-29T20:21:31+01:00)
brew install difftastic # 79.6MB, Rust, structural diff that understands syntax, >30 languages parsed with tree-sitter; `difft v1 v2`, `git dft` for diff, `git dlog` for log, see .gitconfig
brew install tig # 1MB, mostly an interactive `git log --patch`
brew install gitui # 6.8MB, Rust, fastest TUI for everything, shows hot-keys - Status/staging with hunks and lines, Log, Stashing, Stashes, push, fetch, branches
brew install lazygit # 22MB, Go, alternative to gitui, maybe slower, but nicer workflow/keybindings, esp. for navigating/staging hunks
brew install hub
brew install gh # https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md
brew install --cask git-credential-manager # 106MB, cross-platform secure storage with browser login and MFA - no need to manually create tokens at https://github.com/settings/tokens; `sudo git credential-manager configure --system; git credential-manager github login`
# brew install --cask sourcetree smartgit gitkraken gitup # tried but don't use
brew install gitwatch # use GitDoc in vscode instead? https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gitdoc
# brew install git-recent # recent branches; use `git branchr` (alias in .gitconfig) which is based on `git branch` and accepts its options like -a to show remote branches
brew install onefetch # 12.8MB, Rust, like neofetch but stats for git repos, shows name, description, HEAD, version, languages, deps, authors, changes, contributors, commits, LOC, size, license
brew install git-quick-stats # 72KB, git statistics: commits per author, year, month, weekday, hour...
brew install git-extras # 418KB, git statistics like `git summary --line` and utilities like `git fork user/repo`
brew install ugit --force # 43KB, Bash, Undo for 20+ git scenarios, either ugit` or `git undo`, --force due to conflict with git-extras/git-undo
brew link --overwrite ugit # overwrites git-extras/git-undo which just undoes commits
brew install jj # 14.5MB, Rust, git-compatible VCS, no index, working copy is auto-committed, conflicts can be committed -> rebase easier, https://martinvonz.github.io/jj/v0.15.1/git-comparison/ - not as polished as sapling but more improvements over git

# secret scanning
brew install gitleaks # 9.2MB, Go, finds hardcoded secrets like passwords, api keys, and tokens in git repos
brew install trufflehog # 95.7MB, Go, can also verify secrets and scan GitHub (orgs, issues, PRs), S3...
brew install git-secrets # 66KB, Shell, mostly for AWS secrets and hooks for repos
(cd /tmp && uvx lastversion --pre --assets --filter arm64 unzip praetorian-inc/noseyparker && mv -f bin/noseyparker ~/.local/bin/) # 20MB, Rust, download binary or docker: https://github.com/praetorian-inc/noseyparker

# vulnerability/license scanning
brew install trivy # 184M, Vulnerability scanner for container images, file systems, and Git repos (2025-04-03T20:50:11+02:00)

# data processing
brew install jq # 1.5MB, C, JSON CLI processor
# Rust alternatives: https://github.com/01mf02/jaq, https://github.com/yamafaktory/jql
brew install jid # 2.4MB, Go, TUI for jq
# brew install noahgorstein/tap/jqp # 11.8MB, Go, TUI for jq
brew install xsv # 3.1MB, Rust, CSV CLI: cat count flatten frequency join search select slice sort split stats table
brew install csvlens # 3MB, Rust, CSV viewer with vim navigation; H for help, Tab to switch row/col/cell selection, Enter to print cell and exit
brew install jless # 2.6MB, JSON viewer for reading, exploring, and searching; shortcuts in :help
brew install fx # 11MB, JSON viewer, collapsed by default, shortcuts on ?
brew install dasel # 18.6MB, Select/modify/convert JSON, TOML, YAML, XML and CSV; 3x faster than jq? `echo '{"name": "Tom"}' | dasel put string '.foo' 'bar' -r json -w yaml`
brew install htmlq # 2.5MB, jq for HTML, pretty basic, no pseudo-classes?, `htmlq --attribute href a`, `htmlq --text .main`
brew install pup # 3.7MB, jq for HTML, many pseudo-classes, `pup 'a attr{href}'`, text{}, json{}, :contains(text), `pup ':parent-of([action="edit"])'` - deprecated
brew install xidel # 3.7MB, jq for HTML/XML/JSON; supports CSS selectors, XPath 3.0, XQuery 3.0, JSONiq or pattern matching; `xidel https://golem.de -e '//a/@href'`; just output extracted html: `xidel https://golem.de --css 'a' -s --printed-node-format=html`; can also follow links: `xidel https://golem.de --follow //a --extract //title`

# databases
# brew install postgresql@15 # 71MB, SQL DB; `brew services start postgresql@15` to enable start on login, `brew services run postgresql@15` to just start

# database management
brew install tableplus # 183MB, Native GUI tool for databases (PostgreSQL, SQLite, Mongo, Cassandra, Redis, Cockroach...) - free trial is limited to 2 opened tabs, 2 opened windows, 2 advanced filters

# network
brew install mosh # 1.1MB, alternative for ssh, local echo, roaming, but UDP dyn. port alloc. 60000-61000
brew install xxh # 806KB, Python, copy shell (zsh, fish, osquery) and plugins to remote host and connect via ssh; `xxh server +s fish`
brew install wget # alt for curl
brew install monolith # 6.6MB, Rust, CLI tool for saving complete web pages as a single HTML file
brew install wakeonlan
# brew install speedtest-cli # 87KB, Python, unoffical CLI for speedtest.net (down/up/ping), `speedtest-cli --json | jq`
brew tap teamookla/speedtest
brew install speedtest # 2.8MB, native, closed source, official CLI for speedtest.net, better than Python one since it shows more info (high/low/jitter) and url of saved results, `speedtest -f json-pretty`
brew install httpie # 17MB, https://httpie.io User-friendly cURL replacement, ex: http POST pie.dev/post hello=world
brew install xh # 8MB, faster httpie in Rust, but only subset of commands, ex: xh httpbin.org/post name=ahmed age:=24; xh :3000/users -> GET http://localhost:3000/users
# https://github.com/asciimoo/wuzz interactive CLI for HTTP request/response; not available in brew, binary only for amd64
brew install curlie # 2.4M, Power of curl, ease of use of httpie (2025-02-03T14:01:10+01:00)
# API clients with GUI:
  # online: https://hoppscotch.io, https://restfox.dev, https://httpie.io/app (no local network)
  # brew install --cask httpie # 372MB, https://httpie.io GUI, only requests and collections
  # brew install postman # 467MB, most features with account, Collections to save requests, create APIs, Mock servers, Monitors, Flows
  # brew install insomnia # 507MB, simpler UI than Postman: Design (OpenAPI, Swagger), Debug (requests), Test (JS expect on requests)
brew install posting # 21M, Python (Textual), TUI API client like Postman (2025-02-03T14:28:51+01:00)
brew install http-toolkit # 327MB, HTTP(S) debugging proxy, analyzer, and client
brew install hettysoft/tap/hetty # 20MB, MITM HTTP(S) proxy with web-ui for logs, search, intercept, edit, replay; `hetty --chrome` to Launch Chrome with proxy settings applied and certificate errors ignored.
brew install mosquitto # MQTT pub/sub
# brew install youtube-dl # download videos from many websites -> yt only ~70KB/s -> replaced with yt-dlp which dl from yt with full speed
brew install yt-dlp/taps/yt-dlp # youtube-dl fork with additional features and fixes: full dl speed, SponsorBlock, yt-dlp --cookies-from-browser chrome --max-downloads 10 --sponsorblock-remove default :ytwatchlater
brew install angry-ip-scanner # 26MB, Network scanner
brew install zenmap # 59MB, GUI for Nmap Security Scanner (2025-03-03T22:56:16+01:00)
# brew install lulu # 26MB, Open-source firewall to block outgoing connections
# brew install insomnia # Intel, 337MB; HTTP and GraphQL Client
mas install 1451685025 # WireGuard VPN client; brew's wireguard-tools has no GUI
brew install tunnelblick # needed for RBG ovpn profile
brew install vnc-viewer # RealVNC viewer
brew install cyberduck # 237MB, client for FTP, SFTP, WebDAV, and cloud storage
brew install forklift # 159MB, (trial) dual-pane finder with compare/sync for FTP, SFTP, WebDAV, and cloud storage
# brew install rclone # 57.7MB, rsync for cloud storage, Google Drive, Dropbox, One Drive, S3, Mega, FTP, SMB
# brew install pcp # 25.5MB, peer-to-peer file transfer based on libp2p - does not need central relay server, but may also not find any peers or take long
# brew install magic-wormhole # 34.6MB (+ 18MB openssl@1.1 + 57.3MB python@3.10), peer-to-peer file transfer
brew install croc # 6.1MB, peer-to-peer file transfer
brew install teamviewer # 227 MB, remote desktop
brew install rustdesk # 55M, Rust, Open source virtual/remote desktop application (2025-02-08T16:14:02+01:00) https://rustdesk.com, can also self-host, has clients for macOS/Windows/Linux/Android/Web
brew install parsec # 6.5MB, fast remote desktop that works well enough for game streaming
# brew install microsoft-remote-desktop # 176MB, Windows Remote Desktop client; a bit laggy, but works, has remote sound -> deprecated by windows-app, will be disabled 2025-09-30
brew install windows-app # 246MB, Windows Remote Desktop (replaces microsoft-remote-desktop)
brew install caddy # 42MB, Go web server with automatic HTTPS (Let's Encrypt), HTTP/3, reverse proxy, load balancing, caching, nicer to use but slower than nginx/haproxy/traefik, https://caddyserver.com - `caddy file-server --domain example.com` `caddy reverse-proxy --from example.com --to localhost:9000`
brew install dufs # 3.4M, Rust, Static file server with upload/edit/search/zip-download (2025-05-18T19:34:01+02:00)
brew install ali # 6.9MB, Generate HTTP load and plot (TUI) the results in real-time
# brew install dog # 650KB, DNS client like dig but with colors, DNS-over-TLS, DNS-over-HTTPS, json; `dog example.net A AAAA NS MX TXT @1.1.1.1` - deprecated
brew install doggo # 10.7MB, DNS client like dog (like dig), but maintained
brew install wtfis # 8.4MB, Passive hostname, domain, and IP lookup tool - need to put VT_API_KEY in ~/.env.wtfis, https://www.virustotal.com/gui/my-apikey
brew install gping # 2.1MB, Ping, but with a graph
brew install trurl # 74KB, CLI for URL parsing and manipulation, see examples: https://github.com/curl/trurl
brew install scilla # 12.3MB, Go, DNS, subdomain, port, directory enumeration tool; `scilla dns -target google.de`; `scilla port -target rpi4`
brew install subfinder # 27.9MB, Go, Subdomain discovery tool -> add Shodan API key to ~/.config/subfinder/provider-config.yaml
brew install httpx # 39.2MB, Go, HTTP toolkit for probing title, status code, cert, tech based on wappalyzer; `echo golem.de | subfinder -silent | httpx -silent -status-code -location -title -server -ip -response-time -tech-detect`
brew install iftop # 138KB, interactive bandwidth monitor, shows connections with RX/TX bars
brew install bmon # 393KB, interactive bandwidth monitor, only shows graphs per interface
# brew install nethogs # 136KB, interactive bandwidth monitor, groups per process - did not work with sudo; use nettop to at least show connections per process
brew install bandwhich # 5.9MB, Rust, bandwidth per process, remote address, connection

# goblint
brew install gmp # needed to build deps
brew install gcc # needed for pre-processing
brew install ant # needed to build g2html
brew install graphviz # needed for graphs in g2html?

# LaTeX
# https://sourabhbajaj.com/mac-setup/LaTeX/ with BasicTeX one would have to install packages with tlmgr
brew install mactex # brew info says 4.4GB but I think df reduced ~7GB
brew install pygments # latex.minted uses pygmentize
brew install skim # does not jump around as Preview.app on reload
brew install qpdf # qpdf --show-npages; instead of pdfinfo from xpdf
# brew install hook # copy links to files, web pages, etc., deep links to text selection in PDF only supported for Skim, not Preview; 30d trial, afterwards only links to emails & web pages. Thought about this before and like the idea, but not its execution.

# fonts - installed to ~/Library/Fonts/ (currently 980MB, ~120MB not due to the below)
# brew tap homebrew/cask-fonts # has been moved to homebrew
# normal fonts
brew install font-inconsolata font-open-sans font-source-code-pro font-anonymous-pro # 347KB 1.1MB 367KB 598KB
# brew install font-consolas-for-powerline font-menlo-for-powerline font-meslo-for-powerline font-monofur-for-powerline font-noto-mono-for-powerline font-anonymice-powerline
# fonts patched for powerline have been replaced by https://www.nerdfonts.com for glyphs
# relevant variants like font-meslo-lg-nerd-font are downloaded via https://github.com/romkatv/powerlevel10k#fonts
# install via brew instead for easy updates
# first size was reported by brew (download?), second is in Finder
# brew install font-noto-nerd-font # 529.7MB - too big
brew install font-jetbrains-mono-nerd-font # 112.4MB 214.2MB
brew install font-meslo-lg-nerd-font # 95.6MB 190.3MB
# brew install font-overpass-nerd-font # 84.6MB
brew install font-geist-mono-nerd-font # 61.0MB 146.6MB, used in iTerm: size 16, anti-aliased, no ligatures
# brew install font-sauce-code-pro-nerd-font # 48.5MB
brew install font-commit-mono-nerd-font # 27.2MB 66MB
brew install font-fira-code-nerd-font # 23.8MB 43.5MB
brew install font-ubuntu-nerd-font # 21.6MB 41.1MB
brew install font-dejavu-sans-mono-nerd-font # 15.5MB 28.8MB
brew install font-hack-nerd-font # 15.3MB 29.1MB
brew install font-anonymice-nerd-font # 14.7MB 26.9MB
brew install font-ubuntu-mono-nerd-font # 13.8MB 26MB
brew install font-gohufont-nerd-font # 13.8MB 26.5MB
brew install font-proggy-clean-tt-nerd-font # 10.5MB 19.2MB
brew install font-droid-sans-mono-nerd-font # 6.8MB 16.4MB
brew install font-inconsolata-nerd-font # 6.7MB 13MB

# tracking
brew install rescuetime # Intel, fails because it requires Rosetta 2 (`sudo softwareupdate --install-rosetta`). Why did the other Intel apps work without installing this?
# WhatPulse neither on brew or app store. Download from https://whatpulse.org
brew install clockify # 95MB, better (& more free features) than Toggl
# install manually: https://whatpulse.org/downloads/ - neither in brew nor in App Store

# images, photos
# brew install imagemagick
# brew install krita # 981MB, painting and sketching, bit nicer than GIMP
# brew install affinity-photo # 2.95GB, nicer photo editing than krita; got Photo, Designer and Publisher in 2021, but on Windows store, no universal license for macOS
brew install gimp # 892M, Free and open-source image editor (2025-02-15T00:35:38+01:00)

# videos: editing, transcoding
brew install ffmpeg # ~1GB due to many codecs as deps
brew install ffmpegthumbnailer # 400KB, lightweight video thumbnailer using ffmpeg, `ffmpegthumbnailer -i *.mp4 -o foo.jpg -s0 -t20`
brew install --cask handbrake # 113MB, video transcoder; also available as formula, but: A full installation of Xcode.app 10.3 is required to compile
# mas install 1351639930 # 4MB, Gifski: crop & convert videos to high-quality GIFs, https://github.com/sindresorhus/Gifski
brew install losslesscut # 320M, Trims video and audio files losslessly (2025-02-03T14:03:55+01:00)

# screen recording
# brew install kap # Intel, 353MB; screen recorder built with web technology
# https://gifcap.dev creates gif from screen recording in the browser
# cmd+shift+5 can record screen or region and produces .mov
# mas install 1592987853 # Screen Recorder by Omi, 43MB, allows to easily record system sound and microphone (needs their audio driver and selecting it as output in e.g. Teams), also does screen recording (but only 1080p in free version) and has editor to cut video
brew install keycastr # 7.2MB, show keystrokes on screen
brew install cap # 120M, Screen recording software (2025-05-26T20:06:10+02:00) open source alternative to Loom etc.

# audio
# brew install audacity # 77MB, cross-platform audio editor
# brew install blackhole-2ch # 108KB, loopback driver that allows applications to pass audio to other applications with zero additional latency; see https://github.com/ExistentialAudio/BlackHole - also shows how to remove audio plug-ins from Audio Devices
brew install switchaudio-osx # 115KB, C, switch audio input/output devices; `SwitchAudioSource -a` lists all, `SwitchAudioSource -s 'MacBook Air Speakers'` to change output
brew install macwhisper # 17MB + 500MB for small model; speech recognition and transcription with openai/whisper

# MIDI (for PianoVision): no simple midi player on brew?! -> VLC can play midi files
#   https://github.com/benwiggy/APPlayMIDI offers a quick look extension (but w/o seek), only play/pause
#   https://github.com/SamusAranX/MinimalMIDIPlayer no quick look extension, but more features (change speed, soundfont, good keybindings)
  uvx lastversion --assets download SamusAranX/MinimalMIDIPlayer # its unzip is broken: https://github.com/dvershinin/lastversion/issues/98
  unzip -d /Applications MinimalMIDIPlayer*.zip
  rm -f MinimalMIDIPlayer*.zip
brew install aria-maestosa # 11.8MB, midi sequencer/editor with wxWidgets UI

# reading, books
brew install calibre # 366MB

# CAD, 3D printing, electronics, IOT
brew install autodesk-fusion # 3.6 GB in ~/Library/Application\ Support/Autodesk/
brew install openscad # 62MB
brew install ultimaker-cura # 617MB
brew install superslicer # 111MB, fork of PrusaSlicer
brew install arduino-ide # 495MB, use vscode/PlatformIO instead, but this has a nice Serial Plotter for simple sensor sketches
brew install kicad # 6.5GB, schema and PCB editor for Gerber files
# brew install --cask homebrew/cask-drivers/qmk-toolbox # 1.8MB, GUI for flashing QMK keyboard firmware, supports most boards/bootloaders
# brew install qmk/qmk/qmk # ~900MB due to arm-/avr-gcc, CLI to build & flash QMK keyboard firmware

# AI, ML, LLMs
brew install ollama # 25M, Create, run, and share large language models (LLMs) (2025-02-23T14:00:08+01:00) port 11434, but no UI; e.g. `ollama run deepseek-r1:8b` (4bit, 4.9GB) - default 7b, 14b model already made mouse lag and slow output
# brew install --cask ollama # 438MB, just a wrapper to run the server via an app that has a menu item where it can be quit - no further UI -> useless
# brew install ollamac # 11M, Interact with Ollama models (2025-02-23T14:56:37+01:00) needs server running, Swift app with UI with log, parameters etc., however, doesn't show text inside <think> and auto-naming of chats is also bad (<think> instead of prompt)
# `uvx open-webui serve` failed to resolve deps...
# probably best to run NextChat or lobe-chat (both TS) via docker

# not available in brew or mas:
# https://www.meta.com/en-gb/help/quest/articles/horizon/getting-started-in-horizon-workrooms/use-computer-in-VR-workrooms/ - Meta Quest Remote Desktop
# https://immersed.com - remote/virtual AR desktop for Meta Quest 3

# many of the rust and go system tools were found via https://github.com/innobead/huber/blob/main/doc/packages.md
# for more see install/macos/old-MBP/Brewfile
# Brewfile in https://github.com/lunaryorn/dotfiles/commit/2d8531881c2bc61f091d83bc2cf02ad6ebb680c6
# https://sourabhbajaj.com/mac-setup/Apps/
