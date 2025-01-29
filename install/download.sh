#!/usr/bin/env bash

# Usually packages are installed via macos/brew.sh or apt.sh, but some (mostly Rust TUI stuff) are only available for other package managers.
# These should be available for both macos and apt-based systems.
# Download either with https://github.com/devmatteini/dra (brew, .deb) or https://github.com/dvershinin/lastversion (pipx, RPM).

# spawn subshell and cd to target in $PATH
(cd ~/.local/bin &&

  # https://github.com/jacek-kurlit/pik - Process Interactive Kill; can filter by name (firefox), path (/usr/bin), port (:3000)
  dra download --install -a jacek-kurlit/pik

)
