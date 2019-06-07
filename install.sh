set -e

echo ">> Get submodules"
git submodule update --init --recursive

# PACKAGES
if [ "$(uname)" == "Darwin" ]; then
  echo ">> [Running macOS]"

  if test ! $(which brew); then
      echo ">> Install homebrew"
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo ">> brew tap ..."
  source install/brew-tap.sh
  echo ">> brew install ..."
  source install/brew.sh
  echo ">> brew cask install ..."
  source install/brew-cask.sh
else
  echo ">> [Running Linux]"

  echo ">> apt install ..."
  source install/apt.sh
fi
# https://wiki.archlinux.org/index.php/Pacman_Tips#Backing_up_and_retrieving_a_list_of_installed_packages
# backup installed packages (alternatively use aura -B and auro -Br)
#comm -23 <(pacman -Qeq|sort) <(pacman -Qmq|sort) > pkglist.txt
# restore
#pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort badpkdlist) )

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

echo ">> Link vim"
ln -sf `pwd`/.vimrc ~
ln -sf `pwd`/.vimrc ~/.config/nvim/init.vim
echo ">> Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo ">> Install vim plugins"
nvim +PlugInstall +qall

# https://github.com/tpope/vim-sensible
# otherwise it puts the files in the current directory
mkdir -p ~/.vim/{swap,backup,undo}

echo ">> Install Tmux Plugin Manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo ">> Done"
