agi() {
  # https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
  sudo apt-get -y -qq install --fix-missing "$@"
}
sudo apt -qq update
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?

# essentials
agi zsh
agi tmux
agi neovim
agi nodejs
agi npm
agi silversearcher-ag
agi libterm-readkey-perl # needed for git config interactive.singleKey on Raspbian
agi xclip # nvim startup on RPi4: sourcing clipboard.vim took 4s with default xsel, see https://github.com/neovim/neovim/issues/7237
