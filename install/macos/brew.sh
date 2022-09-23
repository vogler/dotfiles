# We could generate a Brewfile with `brew bundle dump` (even with cask & mas), but would lose format/comments every run.
# So we just use a shell script to install each package. Also, sometimes there's some post-install linking to be done.

# $HOMEBREW_PREFIX changed from /usr/local on Intel to /opt/homebrew on ARM
# Some opam packages don't consider this yet, so we link it back on ARM (share is not needed for opam but for zsh completions to load):
[[ $(uname -m) == "arm64" ]] && sudo ln -sfn /opt/homebrew/{include,lib,share} /usr/local/

# Intel (Activity Montior > Kind) means it runs with Rosetta which is a bit slower and results in more memory pressure

# OS tools
brew install mas # CLI for macOS App Store
brew install m-cli # CLI for macOS and stock apps
brew install dockutil # edit Dock (used in dock.sh)
# brew install cheatsheet # hold cmd key to show overlay with all shortcuts of current application
brew install qlstephen qlimagesize qlvideo # https://github.com/sindresorhus/quick-look-plugins
# Apple doc says quicklook generators are only called upon demand (so no overhead for mds?)
# more: https://github.com/haokaiyang/Mac-QuickLook; macOS already handles: csv, stl; maybe interesting: quicklook-dot, QLMarkdownGFM (instead of qlmarkdown), QLPrettyPatch, QLMobi
# qlcolorcode did not show text for .sh, .ml, etc. (stock macOS at least shows unhighlighted text); did not want to fiddle with content-types: https://github.com/anthonygelibert/QLColorCode#adding-language-types
# glance highlights all those correctly, .ts can't be handled (.tsx, .js work): https://github.com/samuelmeuli/glance#faq, also said some .zip would be password-protected and did not show anything when it was not
brew install glance # TODO discontinued; need to open Glance.app first; replaces qlcolorcode qlmarkdown quicklook-json
xattr -d -r com.apple.quarantine ~/Library/QuickLook # remove plugins from quarantine
# brew install shortery # 6.9MB, triggers for Shortcuts, tried Sleep/Wake Up to log to file, but did not work
# brew install sound-control # 23MB, 14d trial, allows to lower volume of speakers connected to display via HDMI/DisplayPort (macOS can't, so volume would need to be changed on speakers (no problem on Windows)) - sometimes made videos hang on sound until clicked on menu icon

# Desktop tools
# brew install sizeup # Intel, unlimited trial
brew install shiftit # Intel, not needed anymore since macOS offers move window to left/right, other display; shortcuts setup by defaults.sh
# mas install 967805235 # Paste - Clipboard Manager; need subscription now to actually use paste...
brew install hammerspoon # 39MB, automation, window management, key/mouse mapping - see .hammerspoon/init.lua
# brew install usb-overdrive # 2.3MB, shareware, device driver for USB/Bluetooth input (mouse, keyboard, gamepad etc.) to configure globally or on a per-application, per-device basis - messed up left click..., per-application not good enough for Books.app
brew install raycast # 75MB, better launcher than Spotlight, Alfred etc., good shortcuts, community extensions/scripts

# HW tools
# brew install tg-pro # trial
# brew install sensei # trial

# browser/-based apps
brew install google-chrome # 922MB
brew install firefox # 344MB, don't really use it, but good to have options
# brew install spotify # Intel, use Chrome App -> same (except no preferences & friends feed?) but more efficient
brew install whatsapp # Intel, use Chrome App instead. Provided by Chrome account sync. To add to your account visit web.whatsapp.com, dot-menu > More Tools > Create Shortcut with open as window
brew install slack
brew install visual-studio-code
# brew install evernote # Intel; not worth the overhead, just use the web-app and eventually something nicer with history
brew install tor-browser # 192MB

brew install dropbox # only 9GB with free plan, moved Screenshots <2021 to PC TODO replace with self-hosted alternative on RPi
brew install telegram # 152MB, 96MB RAM, Swift, narrow: chats>chat
brew install telegram-desktop # 216MB, 340MB RAM, C++ webkit?, chats on side, can export chat data (settings > advanced)
brew install zoom # 98MB, some meetings can't be done in the browser?
brew install libreoffice
# mas install 1030461463 # PDFCombo: merge PDFs and preserve the TOC
# brew install pdf-expert # 200MB, more features than Preview.app: annotations, edit text, merge, crop, clear, margins, OCR, better reduce file size export. Free version useless and full version 140€ or 80€/year.
# https://outbankapp.com neither in brew nor mas (but finds outbank in App Store)
brew install iina # media player
brew install raspberry-pi-imager # install different OSes to microSD
brew install numi # 49MB, calculator app with unit conversions and variables
brew install portfolioperformance # 168MB, Internal and True-Time Weighted Rate of Return, graphs etc., can import PDFs of transactions from ING, but needs manual work; probably works for degiro as well
brew install --cask r # 95MB, Environment for statistical computing and graphics; https://www.coursera.org/learn/practical-time-series-analysis

# sys tools
brew install neovim # editor, no need for vim, config in .vimrc
brew install iterm2 # 78MB, better Terminal.app, https://sourabhbajaj.com/mac-setup/iTerm/
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
brew install warp # 147MB, fast rust-based terminal, bit more modern than iterm, but pretty similar, TODO colors and font in vim are off
brew install tmux # terminal multiplexer
brew install coreutils # newer than macOS
brew install moreutils # more tools: ts for prefixing timestamps, parallel, combine, sponge etc.
brew install gnu-time # gtime has more features than the builtin time command
brew install grep # newer than macOS: 3.6 vs 2.5.1-FreeBSD
brew install gnu-sed # newer than macOS: 4.8 vs 2017 BSD?
brew install less # newer than macOS: 590 vs 487
brew install rsync # newer than macOS: 3.2.3 vs 2.6.9
brew install htop # improved top (interactive process viewer)
brew install exa # Modern replacement for 'ls'
brew install tree # `exa --tree --level=2` has colors and can show meta-data with --long
brew install tldr # `tldr tar` shorter than `curl cheat.sh/tar` and works offline
brew install bat # cat with syntax highlighting and Git integration
brew install fd # Simple, fast and user-friendly alternative to find
brew install the_silver_searcher # 172KB, ag: Code-search similar to ack, but faster [C]
brew install ripgrep # 5.8MB, rg: Code-search similar to ag, but faster [Rust]
brew install ugrep # 1.2MB, ug: grep with interactive TUI (-Q), fuzzy search, hexdump, search binary, archives, compressed files (-z), documents (PDF, pandoc, office, exif...), output as JSON, CSV...
brew install pdfgrep # `pdfgrep -nH PATTERN *.pdf` as alternative (with page number) to `ug --filter='pdf:pdftotext % -' PATTERN *.pdf`
brew install ncdu # NCurses Disk Usage
brew install p7zip # 7z with support for Brotli, Fast LZMA2, LZ4, LZ5, Lizard and Zstd
brew install the-unarchiver # unpack .rar
brew install mosh # alternative for ssh, local echo, roaming, but UDP dyn. port alloc. 60000-61000
brew install watch # Executes a program periodically, showing output fullscreen
brew install watchexec # 5.7MB, Execute commands when watched files change. `watchexec --clear --notify -- ls -lah`, `watchexec -e js,css --restart -- npm start`
brew install mmv # move/copy/append/link multiple files by wildcard patterns
brew install figlet # Banner-like program prints strings as ASCII art
brew install gum # 25MB, fancy input for shell scripts: choose a b, input, write, confirm
brew install fzf # 2.7MB, Command-line fuzzy finder written in Go
brew install neofetch # system information with OS + logo, host, kernel, uptime, packages, shell, resolution, DE, WM, terminal, CPU, memory

# programming languages
# macOS ships ruby 2.6.3, python 2.7.16; python3 installed as dep; typescript via npm
brew install ptpython # better Python REPL
brew install node # JavaScript; includes npm
brew install opam # OCaml
brew install java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk # For the system Java wrappers to find this JDK
# brew install cling # C++ REPL based on LLVM and Clang
mkdir -p ~/.local/bin
ln -sfn /Library/Developer/CommandLineTools/usr/bin/clangd ~/.local/bin/ # used for coc-clangd in nvim

# dev tools
brew install tokei # count code lines fast and by language
brew install semgrep # semantic grep: lightweight static analysis for many languages
brew install rlwrap # used in ocaml alias since it has no readline support; use utop for better REPL
brew install pkg-config
brew install autoconf automake # autotools
brew install heroku/brew/heroku
# mas install 1388020431 # DevCleaner for Xcode: cleans cache files (none if not actually using Xcode)
brew install devutils # 48MB, demo, GUI with converters for unix time, base64, URLs, regex, JSON, CSV, Markdown etc.
brew install --cask docker # 1.5 GB, hate it, only gave in for avoiding captcha with headless playwright
brew install dive # 10MB, explore layers in docker images
brew install ctop # 8.9MB, Top-like interface for container metrics

# git
# brew install diff-so-fancy # within-line highlights
brew install git-delta # as diff-so-fancy but with language syntax highlighting, side-by-side, etc.
brew install tig # Text interface for Git repositories
brew install hub
brew install gh # https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md
# brew install --cask sourcetree smartgit gitkraken gitup # tried but don't use
brew install gitwatch # use GitDoc in vscode instead? https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gitdoc
# brew install git-recent # recent branches; use `git branchr` (alias in .gitconfig) which is based on `git branch` and accepts its options like -a to show remote branches

# data processing
brew install jq # JSON CLI processor
brew install xsv # CSV CLI: cat count flatten frequency join search select slice sort split stats table
brew install jid # Json incremental digger
brew install postgresql # SQL DB; `brew services start postgresql` to enable start on login, `brew services run postgresql` to just start

# network
brew install wget # alt for curl
brew install httpie # 17MB, https://httpie.io User-friendly cURL replacement, ex: http POST pie.dev/post hello=world
# brew install --cask httpie # 372MB, https://httpie.io Desktop App/GUI similar to Postman
brew install mosquitto # MQTT pub/sub
# brew install youtube-dl # download videos from many websites -> yt only ~70KB/s -> replaced with yt-dlp which dl from yt with full speed
brew install yt-dlp/taps/yt-dlp # youtube-dl fork with additional features and fixes: full dl speed, SponsorBlock, yt-dlp --cookies-from-browser chrome --max-downloads 10 --sponsorblock-remove default :ytwatchlater
brew install angry-ip-scanner
# brew install insomnia # Intel, 337MB; HTTP and GraphQL Client
mas install 1451685025 # WireGuard VPN client; brew's wireguard-tools has no GUI
brew install tunnelblick # needed for RBG ovpn profile
brew install vnc-viewer # RealVNC viewer
brew install cyberduck # client for FTP, SFTP, WebDAV, and cloud storage
brew install teamviewer # 227 MB
brew install http-toolkit # 327MB, HTTP(S) debugging proxy, analyzer, and client
brew install caddy # 42MB, Go web server with automatic HTTPS (Let's Encrypt), HTTP/3, reverse proxy, load balancing, caching, nicer to use but slower than nginx/haproxy/traefik, https://caddyserver.com - `caddy file-server --domain example.com` `caddy reverse-proxy --from example.com --to localhost:9000`

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

# fonts
brew tap homebrew/cask-fonts
brew install svn # needed for installing some fonts...
brew install font-inconsolata font-open-sans font-source-code-pro font-source-sans-pro font-anonymous-pro
brew install font-dejavu-sans-mono-for-powerline font-droid-sans-mono-for-powerline font-inconsolata-for-powerline font-inconsolata-for-powerline font-source-code-pro-for-powerline
brew install font-consolas-for-powerline font-menlo-for-powerline font-meslo-for-powerline font-monofur-for-powerline font-noto-mono-for-powerline font-anonymice-powerline
# brew install font-meslo-lg-nerd-font # relevant variants are downloaded via https://github.com/romkatv/powerlevel10k#fonts - see https://www.nerdfonts.com for glyphs

# tracking
brew install rescuetime # Intel, fails because it requires Rosetta 2 (`sudo softwareupdate --install-rosetta`). Why did the other Intel apps work without installing this?
# WhatPulse neither on brew or app store. Download from https://whatpulse.org
brew install clockify # 95MB, better (& more free features) than Toggl

# image/video/books
# brew install imagemagick
brew install ffmpeg # ~1GB due to many codecs as deps
brew install --cask handbrake # video transcoder; also available as formula, but: A full installation of Xcode.app 10.3 is required to compile
# brew install kap # Intel, 353MB; screen recorder built with web technology
# https://gifcap.dev creates gif from screen recording in the browser
# cmd+shift+5 can record screen or region and produces .mov
brew install calibre # 366MB

# CAD, 3D printing, electronics, IOT
brew install autodesk-fusion360 # 3.6 GB in ~/Library/Application\ Support/Autodesk/
brew install openscad # 62MB
brew install ultimaker-cura # 617MB
brew install superslicer # 111MB, fork of PrusaSlicer
brew install arduino # 500MB, use vscode/PlatformIO instead, but this has a nice Serial Plotter for simple sensor sketches
brew install kicad # 6.5GB, schema and PCB editor for Gerber files
brew install --cask homebrew/cask-drivers/qmk-toolbox # 1.8MB, GUI for flashing QMK keyboard firmware, supports most boards/bootloaders
brew install qmk/qmk/qmk # ~900MB due to arm-/avr-gcc, CLI to build & flash QMK keyboard firmware

# for more see install/macos/old-MBP/Brewfile
# Brewfile in https://github.com/lunaryorn/dotfiles/commit/2d8531881c2bc61f091d83bc2cf02ad6ebb680c6
# https://sourabhbajaj.com/mac-setup/Apps/
