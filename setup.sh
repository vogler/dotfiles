#!/bin/bash
set -e # immediately exit if any command has a non-zero exit status

echo "This will setup my basic environment for macOS or Linux."
echo "Possible arguments for extended setup: smart-home"

# Ask for the administrator password upfront. From https://mths.be/macos
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

has(){ # check if a command is available
  hash "$1" 2>/dev/null
}

git-get(){ # as git clone, but skip instead of fail if target exists # TODO update if exists? lockfile for commit?
  [ ! -d "$2" ] && git clone $1 $2 || true
}

lnsf(){ # make a symbolic link in home to dotfiles, create directories if needed
  d=$(dirname "$@")
  mkdir -p "~/$d"
  ln -sf `pwd`/"$@" ~/"$@"
}

echo_bold(){ echo -e '\033[1;32m'"$1"'\033[0m'; } # should be bold green, but is bold white. green somehow only works with 0 (regular) instead of 1 (bold).

echo_bold ">> Get submodules"
git submodule update --init --recursive

config=~/.config
# system packages
if [ "$(uname)" == "Darwin" ]; then
  echo_bold ">> [Running macOS]"
  config=~/Library/Application\ Support

  if ! has git; then # TODO check if this really does not exist; think I could execute `git` but it would then install the Command Line Tools
    echo_bold ">> install Command Line Tools of Xcode" # git, make, clang, gperf, m4, perl, svn, size, strip, strings, libtool, cpp, what...
    xcode-select --install; echo "Press Enter when installed to continue."; read # TODO get rid of read and wait instead for it to finish or don't do anything if already installed
  fi

  [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  if ! has brew; then
    echo_bold ">> Install homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ $(uname -m) == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo_bold ">> brew install ..."
  source install/macos/brew.sh $*

  echo_bold ">> set defaults"
  # can't change settings before installing an application! e.g. 'Couldn't find an application named "Skim"; defaults unchanged'
  source install/macos/defaults.sh # TODO sourcing this seems not enough, after execute afterwards the defaults were set

  echo_bold ">> remove/add apps in dock"
  source install/macos/dock.sh

  if [ ! -d ~/.ssh ]; then # only generate if it was not copied before
    echo_bold ">> generate ssh key for this machine and copy it to rpi3/rpi4"
    ssh-keygen -t ed25519
    ssh-add -AK ~/.ssh/id_ed25519 # https://apple.stackexchange.com/a/250572
    ln -sf `pwd`/.ssh/config ~/.ssh/config
    ssh-copy-id pi@rpi3
    ssh-copy-id pi@rpi4
  fi

  echo_bold ">> link vscode config"
  cd macos
  lnsf Library/Application\ Support/Code/User/settings.json
  lnsf Library/Application\ Support/Code/User/keybindings.json
  lnsf .hammerspoon/init.lua
  lnsf .hammerspoon/Spoons
  cd ..
elif has apt; then
  echo_bold ">> [Running Linux]" # current setup only for RPi or server (both via ssh)

  echo_bold ">> apt install ..."
  source install/apt.sh $*

  # only has binary packages for x86_64, https://docs.brew.sh/Homebrew-on-Linux#arm
  if [[ "$*" == *linuxbrew* ]] && ! has brew && [ "$(uname -m)" == "x86_64" ]; then
    echo ">> Install linuxbrew"
    CI=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    brew tap git-time-metric/gtm
    brew install gtm
  fi
else
  echo "Unsupported system! I can only install packages for macOS or Linux with apt."
  exit
fi

# ocaml/opam
if [[ "$*" == *ocaml* ]]; then
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
fi

# js/npm
sudo npm install -g npm-check-updates

# python/pip
mkdir -p "$config/ptpython" # not .config on macOS...
# ln -sf {`pwd`,~}/.config/ptpython/config.py
ln -sf `pwd`/.config/ptpython/config.py "$config/ptpython"

# TODO this needs to be rethought
# echo_bold ">> Link *.symlink"
# source install/link.sh $*
ln -sf `pwd`/.dir_colors ~

# git
ln -sf `pwd`/.gitconfig ~
# no branching in .gitconfig -> set OS-specific config via commands:
[ "$(uname)" == "Darwin" ] && sudo git config --system --replace-all credential.helper osxkeychain
# [ "$(uname)" == "Linux" ] && sudo git config --system --replace-all credential.helper 'cache --timeout=604800' # keep in memory for 7 days
[ "$(uname)" == "Linux" ] && sudo git config --system --replace-all credential.helper store # plain-text in ~/.git-credentials ! --global instead of --system sets it in ~/.gitconfig
ln -sf `pwd`/.gitignore_global ~
# sudo install install/repos/gitwatch/gitwatch.sh /usr/local/bin/gitwatch

# zsh
echo_bold ">> Link prezto for zsh"
ln -sf `pwd`/.zprezto ~
cat <<EOT | zsh
setopt EXTENDED_GLOB
for rcfile in "\${ZDOTDIR:-\$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -sf "\$rcfile" "\${ZDOTDIR:-$HOME}/.\${rcfile:t}"
done
EOT
if [ $SHELL != "/bin/zsh" ]; then
    echo_bold ">> Set zsh as default shell"
    chsh -s /bin/zsh
fi
# unlink .zlogout since it prints a useless message to stderr which makes Terminal.app not close a tab on ^d but only show this message without a prompt due to the default setting 'Profiles > Shell > Close if the shell exited cleanly'
rm -f ~/.zlogout

# tmux
ln -sf `pwd`/.tmux.conf ~
echo_bold ">> Install Tmux Plugin Manager"
git-get https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo_bold ">> Install Tmux plugins"
# `tmux source-file` fails if not in tmux with 'no server running on /private/tmp/tmux-501/default'
if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  tmux source-file ~/.tmux.conf # need to reload config before tpm can install plugins
  ~/.tmux/plugins/tpm/bin/install_plugins
else
  tmux new-session -d -s tpm_install ~/.tmux/plugins/tpm/bin/install_plugins
fi

# vim
echo_bold ">> Link vim"
ln -sf `pwd`/.vimrc ~
mkdir -p ~/.config/nvim
ln -sf `pwd`/.config/nvim/init.vim ~/.config/nvim/
mkdir -p ~/.vim/{swap,backup,undo} # otherwise https://github.com/tpope/vim-sensible puts the files in the current directory
echo_bold ">> Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo_bold ">> Install vim plugins"
nvim +PlugInstall +qall

# vim already asks for the WakaTime API-key, but still need pip package for zsh integration
source wakatime.sh

if [[ "$*" == *smart-home* ]]; then
  # this is done in install/apt.sh for rpi3 and rpi4
  echo
fi

echo_bold ">> Done"
