#!/bin/bash
set -e

# This will setup my basic environment for macOS or Linux.
# After that more specific extensions are handled.

has(){ # check if a command is available
  hash "$1" 2>/dev/null
}

git-get(){ # as git clone, but skip instead of fail if target exists # TODO update if exists? lockfile for commit?
  [ ! -d "$2" ] && git clone $1 $2 || true
}

echo ">> Get submodules"
git submodule update --init --recursive

# system packages
if [ "$(uname)" == "Darwin" ]; then
  echo ">> [Running macOS]"

  if ! has brew; then
      echo ">> Install homebrew"
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo ">> brew tap ..."
  source install/brew-tap.sh $*
  echo ">> brew install ..."
  source install/brew.sh $*
  echo ">> brew cask install ..."
  source install/brew-cask.sh $*

  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2"
  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
else
  echo ">> [Running Linux]" # current setup only for RPi or server (both via ssh)

  echo ">> apt install ..."
  source install/apt.sh $*

  # only has binary packages for x86_64, https://docs.brew.sh/Homebrew-on-Linux#arm
  if ! has brew && [ "$(uname -m)" == "x86_64" ]; then
    echo ">> Install linuxbrew"
    CI=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    brew tap git-time-metric/gtm
    brew install gtm
  fi
  # echo ">> brew tap ..."
  # source install/brew-tap.sh $*
  # echo ">> brew install ..."
  # source install/brew.sh $*
fi

# ocaml/opam
if ! has opam; then
  echo | sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
  # don't use sandboxing/bubblewrap in WSL because it fails: https://github.com/ocaml/opam/issues/3505
  if [[ $(uname -r) =~ Microsoft$ ]]; then
    opam init -y -a --disable-sandboxing
    # there is no --disable-sandboxing for `opam install`, so we need to change the config... see https://github.com/ocaml/opam-repository/issues/12050#issuecomment-393478072
    sed -i -E '/wrap-|sandbox.sh/d' ~/.opam/config
  else
    opam init -y -a
  fi
  opam install -y utop
fi

# TODO this needs to be rethought
# echo ">> Link *.symlink"
# source install/link.sh $*

# git
ln -sf `pwd`/.gitconfig ~
# no branching in .gitconfig -> set OS-specific config via commands:
[ "$(uname)" == "Darwin" ] && sudo git config --system --add credential.helper osxkeychain
[ "$(uname)" == "Linux" ] && sudo git config --system --add credential.helper 'cache --timeout=604800'
if [ "$(uname)" == "Linux" ] && ! has diff-highlight; then # only needed because diff-so-fancy fails when used as interactive.diffFilter
  # this is only a problem on Debian https://bugs.launchpad.net/ubuntu/+source/git/+bug/1713690
  sudo make -B -C /usr/share/doc/git/contrib/diff-highlight diff-highlight
  sudo ln -sf /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/bin/;
fi
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
echo ">> Install Tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

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

# vim already asks for the WakaTime API-key, but still need pip package for zsh integration
source wakatime.sh

ln -sf `pwd`/.dir_colors ~

if [[ "$*" == *smart-home* ]]; then
  echo ">> smart-home"
fi

echo ">> Done"