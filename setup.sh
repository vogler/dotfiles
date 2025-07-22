#!/bin/bash
set -euo pipefail # exit on error, error on undef var, error on any fail in pipe (not just last cmd); add -x to print each cmd; see https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425

trap 'echo "ERROR: $BASH_SOURCE:$LINENO $BASH_COMMAND" >&2' ERR

echo "This will setup my basic environment for macOS or Linux."
echo "Possible arguments for extended setup: linuxbrew latex smart-home ocaml"
# https://github.com/charmbracelet/gum - nice, but would need to install package first...
# mods=$(gum choose --no-limit base linuxbrew latex smart-home ocaml)

# Ask for the administrator password upfront. From https://mths.be/macos
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

date

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

config=~/.config # local config for Linux, overwritten below for macOS

# install system packages
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
  echo_bold ">> [Running apt-based Linux]" # current setup only for RPi or server (both via ssh)

  # Set time zone for local time
  sudo timedatectl set-timezone Europe/Berlin

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
npm install -g npm-check-updates # 17.1MB, ncu to check dependencies for updates; ncu -u to update package.json; ncu -i for interactive; ncu -g for global packages
npm install -g taze # 6.2MB, newer alternative, `taze` to check within range, `taze major -w` to update package.json to newest deps
npm install -g typescript typescript-language-server # 38.7MB + 1.7MB, used for lsp in helix and probably later also for nvim when changing from coc to nvim-cmp
npm install -g howfat # 1.2MB, show npm package size, #deps, #files, license as tree, table, json, simple - all info from npmjs.com, not local size on disk
npm install -g zx # 12.7MB, JS as replacement for shell scripts, https://github.com/google/zx
npm install -g daff # 1.8MB, align and compare tables, can produce and apply tabular diffs, `daff a.csv b.csv`; git: works with `GIT_PAGER=less git diff` (can't have delta as pager); see .gitconfig and .config/git/attributes
npm install -g git-split-diffs # 20MB, TS, Syntax highlighted side-by-side diffs in your terminal; alternative to delta (Rust)
# npm install -g marked # 410KB, markdown parser/compiler: `marked -o foo.html foo.md`

# python/pipx
mkdir -p "$config/ptpython" # not .config on macOS...
# ln -sf {`pwd`,~}/.config/ptpython/config.py
ln -sf `pwd`/.config/ptpython/config.py "$config/ptpython"
# Only install packages via ~pipx~ uv and not with pip! Only use it where brew's version of package is too old or not available at all.
# `uv tool install lastversion`, `uvx lastversion`, replaces most other Python tools incl. Poetry, `uvx` -> `.cache/uv`, `uv tool install` -> `.local/{bin,share/uv/tools}`
uv tool install pipdeptree # 7MB, tree of deps: pipdeptree -p apprise; reverse: pipdeptree -r -p requests
uv tool install lastversion # 6.5MBMB, find/download latest version of some software on GitHub, GitLab, BitBucket, PyPi, SourceForge, Wikipedia... better `export GITHUB_API_TOKEN=...` to avoid API rate limit; https://github.com/dvershinin/lastversion
uv tool install fritzconnection # 2.6MB, control FritzBox, executables: fritzcall, fritzconnection, fritzhomeauto, fritzhosts, fritzmonitor, fritzphonebook, fritzstatus, fritzwlan
uv tool install tqdm # 0.4MB, progress meter, `seq 9999999 | tqdm --bytes | wc -l`

# TODO this needs to be rethought
# echo_bold ">> Link *.symlink"
# source install/link.sh $*
ln -sf `pwd`/.dir_colors ~

# git
ln -sf `pwd`/.gitconfig ~
# no branching in .gitconfig -> set OS-specific config via commands:
[ "$(uname)" == "Darwin" ] &&  sudo git credential-manager configure --system # sudo git config --system --replace-all credential.helper osxkeychain
# [ "$(uname)" == "Linux" ] && sudo git config --system --replace-all credential.helper 'cache --timeout=604800' # keep in memory for 7 days
[ "$(uname)" == "Linux" ] && sudo git config --system --replace-all credential.helper store # plain-text in ~/.git-credentials ! --global instead of --system sets it in ~/.gitconfig
ln -sf `pwd`/.gitignore_global ~
# sudo install install/repos/gitwatch/gitwatch.sh /usr/local/bin/gitwatch # installed via brew
mkdir -p "$config/lazygit" && ln -sf {`pwd`/.config,"$config"}/lazygit/config.yml

# gh (GitHub CLI) extensions
# https://docs.github.com/en/copilot/github-copilot-in-the-cli/using-github-copilot-in-the-cli
# list: `gh ext ls`
# browse in TUI: `gh ext browse`
gh ext install dlvhdr/gh-dash # CLI dashboard for PRs, issues
gh ext install github/gh-copilot # `gh copilot suggest`, `gh copilot explain "tar -xvf foo.tar.xz"`
gh ext install yusukebe/gh-markdown-preview # use GitHub's API to render Markdown
gh ext install gennaro-tedesco/gh-f # uses fzf for staging, workflow runs, grep, prs, branches, diffs, tags, issues
gh ext install meiji163/gh-notify # display notifications, e.g. `gh notify -e goblint -p` (only participating or mentione)
gh ext install mona-actions/gh-repo-stats # statistics for an organization's repos as .csv
gh ext install advanced-security/gh-sbom # generate SBOMs as SPDX json including 'licenseConcluded' for npm deps
gh ext install korosuke613/gh-user-stars # fzf list of starred repos, doesn't cache the >1k repos...
gh ext install matt-bartel/gh-clone-org # clone all repositories in an organization (optional filters), if exists, switch to default branch and pull
gh ext install fchimpan/gh-workflow-stats # success rate & execution time (min, max, avg, med, std) of workflows & jobs, e.g. `gh workflow-stats --org vogler --repo free-games-claimer -f docker.yml`
gh ext install sheepla/gh-userfetch # like neofetch for a GitHub profile
gh ext install nektos/gh-act # run GitHub actions locally using nektos/act
gh ext install gennaro-tedesco/gh-i # search issues, `gh i` (default state:any author:@me where:any), `gh i -s open --me=false -u=@me`
# gh ext install hectcastro/gh-metrics # metrics for PRs: commits, changes, files, comments, participants, time to first/last review, merge
gh ext install HaywardMorihara/gh-tidy # check out & pull, `git gc` to optimize local repo, check for merged branches/PRs and asks to delete them
gh ext install mtoohey31/gh-foreach # clone and execute commands across multiple repos, `gh foreach run --regex='chrom.*' tokei` --languages=c
# gh ext install schleiden/gh-actionlint # just runs actionlint which needs to be installed

# zsh: fork of https://github.com/sorin-ionescu/prezto
echo_bold ">> Get submodules"
echo_bold ">> zsh: clone fork of prezto to ~/.zprezto"
git-get https://github.com/vogler/prezto ~/.zprezto
git -C ~/.zprezto submodule update --init --recursive
echo_bold ">> zsh: link config"
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
# prompt for prezto: https://github.com/romkatv/powerlevel10k
ln -sf `pwd`/.p10k.zsh ~

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
git-get https://github.com/vogler/config-nvim-astro ~/.config/nvim-astro/
mkdir -p ~/.vim/{swap,backup,undo} # otherwise https://github.com/tpope/vim-sensible puts the files in the current directory
echo_bold ">> Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo_bold ">> Install vim plugins"
nvim +PlugInstall +qall
nvim +CocUpdateSync +qall

# vim already asks for the WakaTime API-key, but still need pip package for zsh integration
source wakatime.sh

if [[ "$*" == *smart-home* ]]; then
  # this is done in install/apt.sh for rpi3 and rpi4
  echo
fi

date
echo_bold ">> Done"
