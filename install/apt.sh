#!/bin/bash
set -e # immediately exit if any command has a non-zero exit status

agi() {
  # https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
  sudo apt-get -y -qq install --fix-missing "$@"
}
sudo apt -qq update
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?

# essentials
agi curl # not installed on Ubuntu 20.04 LTS
agi zsh # better shell than bash
agi tmux # terminal multiplexer
agi neovim # editor - Ubuntu 20.04 only ships 0.4.3, but coc extension requires >=0.5.0, however no more startup errors with coc and 0.4.3
agi snapd # more/newer packages, https://snapcraft.io
sudo snap install nvim --classic || echo "Fallback to apt's neovim." # Virtuozzo/OpenVZ: https://community.letsencrypt.org/t/system-does-not-fully-support-snapd-cannot-mount-squashfs-image-using-squashfs/132689/2
agi tig # Text interface for Git repositories
# arch=$([[ $(uname -m) == "x86_64" ]] && echo "amd64" || echo "armhf")
arch=$(dpkg --print-architecture)
musl=$([[ $(lsb_release -r | cut -f2) == "20.04" ]] && echo "" || echo "-musl") # https://github.com/dandavison/delta/issues/504
curl -fsSL https://github.com/dandavison/delta/releases/download/0.11.0/git-delta${musl}_0.11.0_$arch.deb -o /tmp/git-delta_$arch.deb && sudo dpkg -i /tmp/git-delta_$arch.deb # A syntax-highlighting pager for git and diff output; TODO watch for update: https://github.com/dandavison/delta#installation
agi tree # `exa --tree --level=2` has colors and can show meta-data with --long
agi htop # nicer ncurses-based process viewer similar to top
agi iotop # shows I/O usage
agi iftop # shows network interface usage
if ! hash node 2>/dev/null || ! (node --version | grep v18); then
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - # Debian's nodejs is too old: 10.24.0
  agi nodejs # JavaScript
fi
# agi npm # node package manager; provided by nodejs from nodesource (8.1.2) vs. sep. package in Debian (5.8.0)
agi fd-find # Simple, fast and user-friendly alternative to find
sudo ln -sf /usr/bin/fdfind /usr/bin/fd
agi silversearcher-ag # ag: Code-search similar to ack, but faster [C]
agi ripgrep # rg: Code-search similar to ag, but faster [Rust]
agi ugrep # ug: grep with interactive TUI (-Q), fuzzy search, hexdump, search binary, archives, compressed files (-z), documents (PDF, pandoc, office, exif...), output as JSON, CSV... - not available on Ubuntu 20.04, but Debian bullseye
agi ncdu # NCurses Disk Usage
agi libterm-readkey-perl # needed for git config interactive.singleKey on Raspbian
# agi xclip # nvim startup on RPi4: sourcing clipboard.vim took 4s with default xsel, see https://github.com/neovim/neovim/issues/7237
# agi unzip bubblewrap m4 # required for opam (m4 only recommended since most packages rely on it)
agi python3-pip
# agi golang
# agi ruby
agi inotify-tools
# agi clang
agi jq # JSON CLI processor
agi moreutils # use ts (timestamp standard input) in systemd services for mqtt subs
agi apt-file # which package provides a file? e.g. apt-file find libportaudio.so
agi nq # lightweight job queue
agi mosh # alternative for ssh, local echo, roaming, but UDP dyn. port alloc. 60000-61000
agi mmv # move/copy/append/link multiple files by wildcard patterns

# GitHub CLI: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -qq
agi gh 

agi youtube-dl
# fork with more features and fixes:
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

# https://gitlab.com/volian/nala - nicer frontend around apt with pretty formatting, parallel downloads, `nala fetch` to select the fastest mirrors, and `nala history` to undo/redo
echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
sudo apt update -qq
agi nala 2>/dev/null || agi nala-legacy # nala for Ubuntu 22.04 / Debian Sid, legacy for older

if [[ "$*" == *latex* ]]; then
  agi texlive-latex-extra
  agi texlive-bibtex-extra
  agi texlive-science
  agi latexmk
  agi python3-pygments
  agi biber
fi

if [[ "$*" == *smart-home* ]]; then
  echo ">> smart-home"
  git clone https://github.com/vogler/smart-home.git
  cd smart-home
  git submodule update --init --recursive
  echo ">>> MQTT"
  agi mosquitto # MQTT server
  agi mosquitto-clients # mosqitto_{pub,sub}
  agi wakeonlan
  if [[ $(hostname) == "rpi3" ]]; then
    agi cec-utils # check/control TV via HDMI
    echo ">>> node-red"
    if [ ! -d ~/.node-red ]; then
      echo "Please restore ~/.node-red" # TODO restore everything but secrets from here
      read
    fi
    # sudo npm install -g --unsafe-perm node-red
    bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) # https://nodered.org/docs/getting-started/raspberrypi - this leaves existing nodejs alone, provides node-red-{start,stop,restart,log}, installs service, npm rebuild
    echo ">>> Restore services"
    cd /etc/systemd/system
    sudo ln -s ~/smart-home/etc/systemd/system/thingspeak.service .
      pip3 install paho-mqtt tsl2561
    sudo ln -s ~/smart-home/etc/systemd/system/mh-z19.service .
    sudo ln -s ~/smart-home/etc/systemd/system/dash.service .
      sudo pip3 install scapy # dash.py needs to run as root
      agi libpcap-dev
    sudo ln -s ~/smart-home/etc/systemd/system/shower.service .
    sudo ln -s ~/smart-home/etc/systemd/system/blood-pressure.service .
    sudo systemctl daemon-reload
    sudo systemctl enable thingspeak mh-z19 dash shower blood-pressure
  elif [[ $(hostname) == "rpi4" ]]; then
    echo ">>> influxdb telegraf chronograf"
    # https://docs.influxdata.com/influxdb/v1.7/introduction/installation/
    wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
    source /etc/os-release
    echo "deb https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
    sudo apt-get update
    agi influxdb telegraf chronograf
    sudo systemctl unmask influxdb.service
    echo 'rsync exisiting /var/lib/{influxdb,chronograf} and link configs from smart-home/etc/{influxdb,telegraf}'
    sudo systemctl start influxdb telegraf chronograf

    echo ">>> grafana"
    # https://grafana.com/docs/grafana/latest/installation/debian/
    agi software-properties-common
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    echo "deb https://packages.grafana.com/oss/deb beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
    sudo apt-get update
    agi grafana
    sudo systemctl daemon-reload
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server

    echo ">>> sound detection"
    agi sox # Swiss army knife of sound processing -> record noise (silence filter) with OctoPrint webcam on rpi4, small/cheap USB microphones were not sensitive enough, but webcam mic is with ~50% when talking at desk (100% gain in alsamixer)
  else
    echo "Unknown hostname: $(hostname)! Must be rpi3 or rpi4"
  fi
fi
