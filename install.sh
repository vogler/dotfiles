#!/bin/bash
set -e

has(){ # check if a command is available
  hash "$1" 2>/dev/null
}

git-get(){ # as git clone, but skip instead of fail if target exists # TODO update if exists? lockfile for commit?
  [ ! -d "$2" ] && git clone $1 $2
}

echo ">> Get submodules"
git submodule update --init --recursive

# PACKAGES
if [ "$(uname)" == "Darwin" ]; then
  echo ">> [Running macOS]"

  if ! has brew; then
      echo ">> Install homebrew"
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo ">> brew tap ..."
  source install/brew-tap.sh
  echo ">> brew install ..."
  source install/brew.sh
  echo ">> brew cask install ..."
  source install/brew-cask.sh

  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2"
  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
else
  echo ">> [Running Linux]" # current setup only for RPi or server (both via ssh)

  echo ">> apt install ..."
  source install/apt.sh

  # if ! has brew; then
  #     echo ">> Install linuxbrew"
  #     sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  # fi
  # echo ">> brew tap ..."
  # source install/brew-tap.sh
  # echo ">> brew install ..."
  # source install/brew.sh
fi
# https://wiki.archlinux.org/index.php/Pacman_Tips#Backing_up_and_retrieving_a_list_of_installed_packages
# backup installed packages (alternatively use aura -B and auro -Br)
#comm -23 <(pacman -Qeq|sort) <(pacman -Qmq|sort) > pkglist.txt
# restore
#pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort badpkdlist) )

# TODO this needs to be rethought
# echo ">> Link *.symlink"
# source install/link.sh

# git
ln -sf `pwd`/.gitconfig ~
# no branching in .gitconfig -> set OS-specific config via commands:
[ "$(uname)" == "Darwin" ] && sudo git config --system --add credential.helper osxkeychain
[ "$(uname)" == "Linux" ] && sudo git config --system --add credential.helper 'cache --timeout=604800'
ln -sf `pwd`/.gitignore_global ~
sudo npm install -g diff-so-fancy

# zsh
echo ">> Link prezto for zsh"
ln -sf `pwd`/.zprezto ~
cat <<EOT | zsh
setopt EXTENDED_GLOB
for rcfile in "\${ZDOTDIR:-\$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -sf "\$rcfile" "\${ZDOTDIR:-$HOME}/.\${rcfile:t}"
done
EOT
if [ $SHELL != "/bin/zsh" ]; then
    echo ">> Set zsh as default shell"
    chsh -s /bin/zsh
fi

# tmux
ln -sf `pwd`/.tmux.conf ~
echo ">> Install Tmux Plugin Manager"
git-get https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# vim
echo ">> Link vim"
ln -sf `pwd`/.vimrc ~
mkdir -p ~/.config/nvim
ln -sf `pwd`/.config/nvim/init.vim ~/.config/nvim/
mkdir -p ~/.vim/{swap,backup,undo} # otherwise https://github.com/tpope/vim-sensible puts the files in the current directory
echo ">> Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo ">> Install vim plugins"
nvim +PlugInstall +qall

echo ">> Done"
