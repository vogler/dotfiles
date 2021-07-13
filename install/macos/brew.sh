# Intel (Activity Montior > Kind) means it runs with Rosetta which is a bit slower and results in more memory pressure

# OS tools
brew install dockutil # for editing Dock in dock.sh
# brew install sizeup # Intel
brew install shiftit # Intel

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

# dev
brew install iterm2
brew install neovim
brew install the_silver_searcher
brew install fd
brew install rlwrap
# brew install coreutils # needed?
brew install pkg-config

# git
brew install diff-so-fancy
brew install hub
brew install gh # https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md
brew install gitwatch

# PL
brew install node # JS
brew install opam # OCaml
# $HOMEBREW_PREFIX changed from /usr/local on Intel to /opt/homebrew on ARM
# Some opam packages don't consider this yet, so we link it back on ARM:
[[ $(uname -m) == "arm64" ]] && sudo ln -s /opt/homebrew/{include,lib} /usr/local/
brew install java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk # For the system Java wrappers to find this JDK

# goblint
brew install gmp
brew install gcc
brew install ant
brew install graphviz # needed?

# LaTeX
brew install mactex
brew install pygments # latex.minted uses pygmentize
