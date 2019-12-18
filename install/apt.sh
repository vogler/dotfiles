agi() {
  sudo apt-get install -yy --fix-missing "$@"
}
sudo apt update
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?

# essentials
agi zsh
agi tmux
agi neovim
agi nodejs
agi npm
