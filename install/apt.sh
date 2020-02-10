agi() {
  # https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
  sudo apt-get -y -qq install --fix-missing "$@"
}
sudo apt -qq update
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?

# essentials
agi zsh
agi tmux
agi tree
agi neovim
agi nodejs
agi npm
agi silversearcher-ag
agi libterm-readkey-perl # needed for git config interactive.singleKey on Raspbian
agi xclip # nvim startup on RPi4: sourcing clipboard.vim took 4s with default xsel, see https://github.com/neovim/neovim/issues/7237
agi unzip bubblewrap m4 # required for opam (m4 only recommended since most packages rely on it)
agi python3-pip
# agi golang
agi ruby
agi inotify-tools
# agi clang
agi jq
agi moreutils

if [[ "$*" == *latex* ]]; then
  agi texlive-latex-extra
  agi texlive-bibtex-extra
  agi texlive-science
  agi latexmk
  agi python3-pygments
  agi biber
fi
if [[ "$*" == *smart-home* ]]; then
  agi mosquitto
  agi mosquitto-clients
  sudo npm install -g --unsafe-perm node-red

  # https://docs.influxdata.com/influxdb/v1.7/introduction/installation/
  wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
  source /etc/os-release
  echo "deb https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
  sudo apt-get update
  agi influxdb telegraf chronograf
  sudo systemctl unmask influxdb.service
  echo 'rsync exisiting /var/lib/{influxdb,chronograf} and link configs from smart-home/etc/{influxdb,telegraf}'
  sudo systemctl start influxdb telegraf chronograf

  # https://grafana.com/docs/grafana/latest/installation/debian/
  agi software-properties-common
  wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
  echo "deb https://packages.grafana.com/oss/deb beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
  sudo apt-get update
  agi grafana
  sudo systemctl daemon-reload
  sudo systemctl start grafana-server
  sudo systemctl enable grafana-server
fi
