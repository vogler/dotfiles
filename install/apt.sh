agi() {
  sudo apt-get install -yy --fix-missing "$@"
}
sudo apt update
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?
agi zsh
agi tmux
agi neovim
