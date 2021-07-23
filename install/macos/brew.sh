# We could generate a Brewfile with `brew bundle dump` (even with cask & mas), but would lose format/comments every run.
# So we just use a shell script to install each package. Also, sometimes there's some post-install linking to be done.

# Intel (Activity Montior > Kind) means it runs with Rosetta which is a bit slower and results in more memory pressure

# OS tools
brew install mas # CLI for macOS App Store
brew install m-cli # CLI for macOS and stock apps
brew install dockutil # edit Dock (used in dock.sh)

# Desktop tools
# brew install sizeup # Intel, unlimited trial
brew install shiftit # Intel
# mas install 967805235 # Paste - Clipboard Manager; need subscription now to actually use paste...

# HW tools
# brew install tg-pro # trial
# brew install sensei # trial

# browser/-based apps
brew install google-chrome
brew install spotify # Intel
brew install whatsapp # Intel
brew install slack
brew install visual-studio-code
# brew install evernote # Intel; not worth the overhead, just use the web-app and eventually something nicer with history

brew install telegram
brew install libreoffice
brew install iina # media player

# sys tools
brew install coreutils # newer than macOS
brew install grep # newer than macOS: 3.6 vs. 2.5.1-FreeBSD
brew install htop

# network
brew install wget
brew install mosquitto

# dev tools
brew install neovim
brew install iterm2
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
brew install tmux
brew install the_silver_searcher
brew install fd
brew install rlwrap
brew install pkg-config

# git
brew install diff-so-fancy
brew install hub
brew install gh # https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md
brew install gitwatch # use GitDoc in vscode instead? https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gitdoc

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
