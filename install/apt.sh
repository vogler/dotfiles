agi() {
  # https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
  sudo apt-get -y -qq install --fix-missing "$@"
}
sudo apt -qq update
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?

# essentials
agi zsh # better shell than bash
agi tmux # terminal multiplexer
agi neovim # editor
agi tig # Text interface for Git repositories
agi tree # `exa --tree --level=2` has colors and can show meta-data with --long
agi htop # nicer ncurses-based process viewer similar to top
agi iotop # shows I/O usage
agi iftop # shows network interface usage
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash - # Debian's nodejs is too old: 10.24.0
agi nodejs # JavaScript
# agi npm # node package manager; provided by nodejs from nodesource (8.1.2) vs. sep. package in Debian (5.8.0)
agi fd-find # Simple, fast and user-friendly alternative to find
sudo ln -sf /usr/bin/fdfind /usr/bin/fd
agi silversearcher-ag # Code-search similar to ack, but faster
agi ncdu # NCurses Disk Usage
agi libterm-readkey-perl # needed for git config interactive.singleKey on Raspbian
agi xclip # nvim startup on RPi4: sourcing clipboard.vim took 4s with default xsel, see https://github.com/neovim/neovim/issues/7237
agi unzip bubblewrap m4 # required for opam (m4 only recommended since most packages rely on it)
agi python3-pip
# agi golang
# agi ruby
agi inotify-tools
# agi clang
agi jq # JSON CLI processor
agi moreutils # use ts (timestamp standard input) in systemd services for mqtt subs
agi apt-file # which package provides a file? e.g. apt-file find libportaudio.so

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
  else
    echo "Unknown hostname: $(hostname)! Must be rpi3 or rpi4"
  fi
fi
