# We could generate a Brewfile with `brew bundle dump` (even with cask & mas), but would lose format/comments every run.
# So we just use a shell script to install each package. Also, sometimes there's some post-install linking to be done.

# Intel (Activity Montior > Kind) means it runs with Rosetta which is a bit slower and results in more memory pressure

# OS tools
brew install mas # CLI for macOS App Store
brew install m-cli # CLI for macOS and stock apps
brew install dockutil # edit Dock (used in dock.sh)
brew install qlstephen qlimagesize qlvideo # https://github.com/sindresorhus/quick-look-plugins
# Apple doc says quicklook generators are only called upon demand (so no overhead for mds?)
# more: https://github.com/haokaiyang/Mac-QuickLook; macOS already handles: csv, stl; maybe interesting: quicklook-dot, QLMarkdownGFM (instead of qlmarkdown), QLPrettyPatch, QLMobi
# qlcolorcode did not show text for .sh, .ml, etc. (stock macOS at least shows unhighlighted text); did not want to fiddle with content-types: https://github.com/anthonygelibert/QLColorCode#adding-language-types
# glance highlights all those correctly, .ts can't be handled (.tsx, .js work): https://github.com/samuelmeuli/glance#faq, also said some .zip would be password-protected and did not show anything when it was not
brew install glance # TODO discontinued; need to open Glance.app first; replaces qlcolorcode qlmarkdown quicklook-json
xattr -d -r com.apple.quarantine ~/Library/QuickLook # remove plugins from quarantine

# Desktop tools
# brew install sizeup # Intel, unlimited trial
brew install shiftit # Intel
# mas install 967805235 # Paste - Clipboard Manager; need subscription now to actually use paste...

# HW tools
# brew install tg-pro # trial
# brew install sensei # trial

# browser/-based apps
brew install google-chrome
# brew install spotify # Intel, use Chrome App -> same (except no preferences & friends feed?) but more efficient
brew install whatsapp # Intel
brew install slack
brew install visual-studio-code
# brew install evernote # Intel; not worth the overhead, just use the web-app and eventually something nicer with history

brew install telegram
brew install libreoffice
brew install iina # media player

# sys tools
brew install coreutils # newer than macOS
brew install grep # newer than macOS: 3.6 vs 2.5.1-FreeBSD
brew install less # newer than macOS: 590 vs 487
brew install rsync # newer than macOS: 3.2.3 vs 2.6.9
brew install htop
brew install tree # `exa --tree --level=2` has colors and can show meta-data with --long
brew install tldr # `tldr tar` shorter than `curl cheat.sh/tar` and works offline
brew install bat # cat with syntax highlighting and Git integration
brew install fd # Simple, fast and user-friendly alternative to find
brew install the_silver_searcher # Code-search similar to ack, but faster
brew install exa # Modern replacement for 'ls'
brew install p7zip # 7z with support for Brotli, Fast LZMA2, LZ4, LZ5, Lizard and Zstd

# network
brew install wget # alt for curl
brew install httpie # https://httpie.io User-friendly cURL replacement
brew install mosquitto # MQTT pub/sub
brew install youtube-dl # download videos from many websites

# dev tools
brew install neovim
brew install iterm2
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
brew install tmux
brew install tokei # count code lines fast and by language
brew install rlwrap # used in ocaml alias since it has no readline support; use utop for better REPL
brew install pkg-config

# data processing
brew install jq # JSON CLI processor
brew install xsv # CSV CLI: cat count flatten frequency join search select slice sort split stats table
brew install jid # Json incremental digger

# git
brew install diff-so-fancy
brew install hub
brew install gh # https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md
brew install gitwatch # use GitDoc in vscode instead? https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gitdoc
# brew install git-recent # recent branches; use `git branchr` (alias in .gitconfig) which is based on `git branch` and accepts its options like -a to show remote branches

# programming
brew install node # JavaScript
brew install opam # OCaml
# $HOMEBREW_PREFIX changed from /usr/local on Intel to /opt/homebrew on ARM
# Some opam packages don't consider this yet, so we link it back on ARM:
[[ $(uname -m) == "arm64" ]] && sudo ln -sfn /opt/homebrew/{include,lib} /usr/local/
brew install java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk # For the system Java wrappers to find this JDK

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

brew tap homebrew/cask-fonts
brew install svn # needed for installing some fonts...
brew install font-inconsolata font-open-sans font-source-code-pro font-source-sans-pro font-anonymous-pro
brew install font-dejavu-sans-mono-for-powerline font-droid-sans-mono-for-powerline font-inconsolata-for-powerline font-inconsolata-for-powerline font-source-code-pro-for-powerline
brew install font-consolas-for-powerline font-menlo-for-powerline font-meslo-for-powerline font-monofur-for-powerline font-noto-mono-for-powerline font-anonymice-powerline

# tracking
# brew install rescuetime # Intel, fails because it requires Rosetta 2 (`sudo softwareupdate --install-rosetta`). Why did the other Intel apps work without installing this?
# WhatPulse neither on brew or app store. Download from https://whatpulse.org

# image/video
# brew install imagemagick
# brew install ffmpeg
brew install --cask handbrake # video transcoder; also available as formula, but: A full installation of Xcode.app 10.3 is required to compile

# for more see install/macos/old-MBP/Brewfile
# Brewfile in https://github.com/lunaryorn/dotfiles/commit/2d8531881c2bc61f091d83bc2cf02ad6ebb680c6
