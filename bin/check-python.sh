#!/bin/bash

# Python tooling is chaos!
# https://m.xkcd.com/1987/
# https://chriswarrick.com/blog/2023/01/15/how-to-improve-python-packaging/
# https://www.youtube.com/watch?v=jVcN49sHbBQ Don't Use Pip For Big Projects - Use These Instead

# set -x # Print command traces before executing command.
# PS4="\033[1;33m>>>\033[0m "; set -x
set -v # Prints shell input lines as they are read.

# Problem: several Python versions, where each installs their own packages...
type python3
python3 --version # this should be the most recent python installed by homebrew
/usr/bin/python3 --version # this is the python that comes with macOS?

# Python + deps installed via homebrew:
brew ls | grep python

# Which homebrew packages use which python version:
for p in $(brew ls | grep 'python@'); do echo "> $p"; brew uses --recursive --installed "$p"; done

# brew doesn't clean this up automatically after upgrades, so if no more package uses an old python version, we need to e.g. run `brew uninstall 'python@3.10'`
# Additionally, the above doesn't even remove the deps of that old version, so we need to `rm -rf /opt/homebrew/lib/python3.10/site-packages`.
# Installed python versions:
brew ls | grep 'python@'

# All site-packages (remove the ones of old versions):
du -hs /opt/homebrew/lib/python3* | sort --version-sort -k 2
# Check what packages may have been installed via pip and then delete the outdated folders above (and reinstall needed tools via homebrew or pipx) since the packages won't work anymore anyway; example: /opt/homebrew/bin/wakatime: bad interpreter: /opt/homebrew/opt/python@3.9/bin/python3.9: no such file or directory

# TODO subtract installed from existing versions

# zsh history may help to find which packages have been manually installed via pip:
grep "pip3\? install" ~/.zsh_history

# check which binaries use an outdated python version and delete them:
ag 'opt/homebrew/opt/python@3.9' /opt/homebrew/bin

# Preferred way to install binary tools is `pipx install ...` since it separates them in venvs (with sharing).
pipx list

dust ~/Library/Application\ Support/pipx

# Still end up with packages installed in normal pip due to homebrew or just by mistake.
pip list

# Problem: run `pip install foo` instead of `pipx install foo` by mistake -> end up with deps of foo still installed even after `pip uninstall foo`.
# Of course, there's no good solution to this since Python tooling is a mess:
# https://stackoverflow.com/questions/7915998/does-uninstalling-a-package-with-pip-also-remove-the-dependent-packages
