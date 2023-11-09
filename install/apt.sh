#!/bin/bash
set -e # immediately exit if any command has a non-zero exit status
# set -v # show input commands as well

trap 'echo "ERROR: $BASH_SOURCE:$LINENO $BASH_COMMAND" >&2' ERR

agi() {
  # https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
  echo "install $@"
  sudo apt-get -y -qq install --fix-missing "$@"
}
sudo apt -qq update && sudo apt -y -qq upgrade
# apt list --installed | sed -e 's/\(.*\)\/.*/agi \1/' # TODO versions? do I really want all packages?

# sections below: apt default sources, cargo, snap, apt additional sources, binary/.deb

# packages installed via apt, default sources:

agi curl # not installed on Ubuntu 20.04 LTS
agi zsh # better shell than bash
agi tmux # terminal multiplexer
agi neovim # editor - Ubuntu 20.04 only ships 0.4.3, but coc extension requires >=0.5.0, however no more startup errors with coc and 0.4.3; installing newer version via snap below
agi tig # Text interface for Git repositories
agi exa # Modern replacement for 'ls'; `exa --long --header --icons --git`; now unmaintained, use eza
# agi rust-lsd # only in unstable so far, `ls` clone with colors, file type icons, `lsd --tree`; looks nicer than exa, but no git status
agi tree # `exa --tree --level=2` has colors and can show meta-data with --long
agi htop # nicer ncurses-based process viewer similar to top
agi iotop # shows I/O usage
agi iftop # shows network interface usage
agi fd-find # Simple, fast and user-friendly alternative to find
sudo ln -sf /usr/bin/fdfind /usr/bin/fd
agi silversearcher-ag # ag: Code-search similar to ack, but faster [C]
agi ripgrep # rg: Code-search similar to ag, but faster [Rust]
[[ $(lsb_release -rs) != "20.04" ]] && agi ugrep # ug: grep with interactive TUI (-Q), fuzzy search, hexdump, search binary, archives, compressed files (-z), documents (PDF, pandoc, office, exif...), output as JSON, CSV... - not available on Ubuntu 20.04, but in 21.10 and Debian bullseye
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
agi pup # jq for HTML, many pseudo-classes, `pup 'a attr{href}'`, text{}, json{}, :contains(text), `pup ':parent-of([action="edit"])'`
agi install jless # JSON viewer for reading, exploring, and searching; shortcuts in :help
agi moreutils # use ts (timestamp standard input) in systemd services for mqtt subs
agi apt-file # which package provides a file? e.g. apt-file find libportaudio.so
agi nq # lightweight job queue
agi mosh # alternative for ssh, local echo, roaming, but UDP dyn. port alloc. 60000-61000
agi mmv # move/copy/append/link multiple files by wildcard patterns
agi neofetch # system information with OS + logo, host, kernel, uptime, packages, shell, resolution, DE, WM, terminal, CPU, memory
agi fzf # Command-line fuzzy finder written in Go
# https://github.com/junegunn/fzf/issues/2790
if [[ ! -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
  sudo curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -o /usr/share/doc/fzf/examples/completion.zsh
  sudo curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -o /usr/share/doc/fzf/examples/key-bindings.zsh
fi
# agi net-tools # Debian `sudo netstat -nltp` = Ubuntu `sudo ss -nltp`; https://askubuntu.com/questions/1025568/has-netstat-been-replaced-with-a-new-tool
agi httpie # https://httpie.io User-friendly cURL replacement, ex: http POST pie.dev/post hello=world
agi nnn # terminal file manager: small and fast, but bare bones without plugins/config; use `nnn -e` to edit text in same terminal instead of via `open`
agi ranger # terminal file manager: slower, but nicer defaults with multi-column layout and automatic preview of many file types
agi broot || "broot not available (Chromebook Debian 11?)" # `br` to navigate big file trees, alt+enter to cd, `br -s` to show sizes
agi clog # Colorized pattern-matching log tail utility, https://taskwarrior.org/docs/clog/, `echo 'foo bar' | clog -d -t -f <(echo 'default rule /foo/ --> bold red match')`
agi hexyl # Command-line hex viewer
agi dog # DNS client like dig but with colors, DNS-over-TLS, DNS-over-HTTPS, json; `dog example.net A AAAA NS MX TXT @1.1.1.1`
agi gping # Ping, but with a graph


# packages installed via cargo:

if [[ "$*" == *cargo* ]]; then # a lot failed or was too slow on rpi3
  # agi cargo
  # first install will update crates.io index which took 20 min on rpi4 and 29 min on rpi3...
  # failed on rpi3 (cargo 1.46.0 via Debian 11): error: failed to parse manifest at `.../spacer.../Cargo.toml`; Caused by: this version of Cargo is older than the `2021` edition, and only supports `2015` and `2018` editions.
  # failed on rpi4 (cargo 1.65.0 via Debian 12): package `eza v0.15.2` cannot be built because it requires rustc 1.70.0 or newer, while the currently active rustc version is 1.63.0
  # curl https://sh.rustup.rs -sSf | sh
  # rpi4: 'error: command failed: 'cargo': No such file or directory (os error 2)'
  # -> need to change default host triple from the detected aarch64-unknown-linux-gnu to arm-unknown-linux-gnueabihf due to the 64bit kernel but 32bit userland, see https://github.com/rust-lang/rustup/issues/3342
  [[ $(hostname) == "rpi4" ]] && (curl https://sh.rustup.rs -sSf | sh -s -- -y --default-host arm-unknown-linux-gnueabihf) # 1min
  [[ $(hostname) == "rpi3" ]] && (curl https://sh.rustup.rs -sSf | sh -s -- -y) # 2m51s, the detected armv7-unknown-linux-gnueabihf is ok (still 32 bit kernel)
  # -> cargo 1.73.0

  # compilation on rpi3 failed for eza; build times are for rpi4

  cargo install pueue # 17m, manage sequential/parallel long-running tasks, `pueued`, `pueue add ls; pueue add sleep 100; pueue; pueue log`
  cargo install eza # 6m, maintained fork of exa; `eza --long --header --icons --git`
  cargo install bottom # 17m, `btm`, Yet another cross-platform graphical process/system monitor (rust) - interactive with mouse and shortcuts
  cargo install diskus # 3m, minimal, 3-10x faster alternative to `du -sh`
  cargo install spacer # 8m, insert spacers with datetime+duration when command output stops, default is 1s, `tail -f some.log | spacer --after 5` (only after 5s instead); `log stream --predicate 'process == "Google Chrome"' | spacer`; 'If you're the type of person that habitually presses enter a few times in your log tail to know where the last request ended and the new one begins, this tool is for you!' :)
  cargo install tailspin # 11m, automatic log file highligher, supports numbers, dates, IP-addresses, UUIDs, URLs and more; pipe to `tspin`
  cargo install onefetch # 33m, like neofetch but stats for git repos, shows name, description, HEAD, version, languages, deps, authors, changes, contributors, commits, LOC, size, license
  cargo install xh # 18m, faster httpie in Rust, but only subset of commands, ex: xh httpbin.org/post name=ahmed age:=24; xh :3000/users -> GET http://localhost:3000/users

  # failed to compile on rpi4:
  # cargo install yazi-fm # terminal file manager: like ranger, but fast, scrollable preview for images, videos, pdfs etc. # cc: error: unrecognized command-line option ‘-m32’; did you mean ‘-mbe32’?
fi


# packages installed via snap:

agi snapd # more/newer packages, https://snapcraft.io
sudo snap set system refresh.retain=2 # https://askubuntu.com/questions/1036633/how-to-remove-disabled-unused-snap-packages-with-a-single-line-of-command
# needed on Chrome OS: via https://cyldx.de/snap-anwendungen-im-linux-modus-von-chrome-os-nutzen-p/ https://medium.com/@eduard_faus/installing-snap-on-chrome-os-d9876bb369c1
if [[ -d /mnt/chromeos ]]; then
  agi libsquashfuse0 squashfuse fuse
  echo "Right click on Terminal > Shut down Linux -- really needed?"
  sudo systemctl enable --now snapd
  # systemctl status snapd
  sudo snap install code --classic # Visual Studio Code
  agi gnome-keyring # needed to stay signed in to GitHub in vscode

fi
sudo snap install nvim --classic # Virtuozzo/OpenVZ: https://community.letsencrypt.org/t/system-does-not-fully-support-snapd-cannot-mount-squashfs-image-using-squashfs/132689/2
sudo snap install procs # modern replacement for `ps aux | grep ..` in Rust, fields for open ports, throughput, container name; ex: procs --tree nvim; procs --watch


# packages installed via apt, additional sources:

if ! hash node 2>/dev/null || ! (node --version | grep v18); then
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - # Debian's nodejs is too old: 10.24.0
  agi nodejs # JavaScript
fi
# agi npm # node package manager; provided by nodejs from nodesource (8.1.2) vs. sep. package in Debian (5.8.0)

# GitHub CLI: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -qq
agi gh 

# https://gitlab.com/volian/nala - nicer frontend around apt with pretty formatting, parallel downloads, `nala fetch` to select the fastest mirrors, and `nala history` to undo/redo
echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
sudo apt update -qq
agi nala 2>/dev/null || agi nala-legacy # nala for Ubuntu 22.04 / Debian Sid, legacy for older

# https://github.com/charmbracelet/gum - fancy input for shell scripts: choose a b, input, write, confirm
# disabled for now due to spamming `apt update`: https://github.com/charmbracelet/gum/issues/154
# echo 'deb [trusted=yes] https://repo.charm.sh/apt/ /' | sudo tee /etc/apt/sources.list.d/charm.list
# sudo apt update && sudo apt install gum


# packages installed via downloading binary or .deb

agi youtube-dl
# fork with more features and fixes:
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
# download YouTube Watch later videos: yt-dlp --cookies-from-browser chrome --max-downloads 10 --sponsorblock-remove default :ytwatchlater
# Chrome OS: https://gist.github.com/vogler/5661b400a63e4c2437bc81a153ac454f

arch=$(dpkg --print-architecture) # amd64, arm64, armhf on RPi (32bit userland)
# gh release download -R dandavison/delta -p '*armhf*' # requires `gh auth login`
# using jq to get latest release from API JSON, see https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8

# https://github.com/dandavison/delta - A syntax-highlighting pager for git and diff output
# musl=$([[ $(lsb_release -r | cut -f2) == "19.10" ]] && echo "-musl" || echo "") # https://github.com/dandavison/delta/issues/504#issuecomment-1164600484
# curl -fsSL https://github.com/dandavison/delta/releases/download/0.14.0/git-delta${musl}_0.14.0_$arch.deb -o /tmp/git-delta.deb && sudo dpkg -i /tmp/git-delta.deb
curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq ".assets[] | select(.name|test(\"$arch\")) | .browser_download_url" -r | wget -q -O /tmp/git-delta.deb -i - && sudo dpkg -i /tmp/git-delta.deb

# https://github.com/ClementTsang/bottom - Yet another cross-platform graphical process/system monitor (rust) - interactive with mouse and shortcuts
curl -s https://api.github.com/repos/ClementTsang/bottom/releases/latest | jq ".assets[] | select(.name|test(\"$arch\")) | .browser_download_url" -r | wget -q -O /tmp/bottom.deb -i - && sudo dpkg -i /tmp/bottom.deb

# https://github.com/jesseduffield/lazygit#ubuntu
arch_alt=$([[ "$arch" == "armhf" ]] && echo "armv6" || echo "x86_64")
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${arch_alt}.tar.gz"
tar xf lazygit.tar.gz lazygit
hash lazygit && lazygit --version
sudo install lazygit /usr/local/bin
rm -f lazygit.tar.gz lazygit

# special sets of packages
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
  curl -sSL https://raw.githubusercontent.com/PierreKieffer/pitop/master/install/install_pitop32.sh | bash # TODO use install_pitop64.sh for 64-bit OS
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
    echo 'rsync existing /var/lib/{influxdb,chronograf} and link configs from smart-home/etc/{influxdb,telegraf}'
    sudo systemctl start influxdb telegraf chronograf

    echo ">>> grafana"
    # https://grafana.com/docs/grafana/latest/installation/debian/
    agi apt-transport-https software-properties-common
    sudo mkdir -p /etc/apt/keyrings/
    wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
    sudo apt-get update
    agi grafana
    sudo systemctl daemon-reload
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server

    echo ">>> Caddy reverse proxy"
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
    sudo apt update -qq
    agi caddy
    sudo setcap cap_net_bind_service=+ep $(which caddy) # allow binding to ports <=1024
    sudo mv /etc/caddy/Caddyfile{,.org}
    sudo ln -s ~/smart-home/etc/caddy/Caddyfile /etc/caddy/
    sudo systemctl restart caddy # needed for lower ports
    # caddy reload # loads ./Caddyfile; TODO link to /etc/caddy/Caddyfile used in service?

    echo ">>> OctoPrint (TODO)" # see {octoprint,webcamd}.service - install via pip instead of source, link .octoprint, restore secrets from somewhere
    agi haproxy # see vogler/smart-home/etc/haproxy/haproxy.cfg
    # TODO replace with Caddy? https://caddyserver.com/docs/install#debian-ubuntu-raspbian

    echo ">>> sound detection"
    agi sox # Swiss army knife of sound processing -> record noise (silence filter) with OctoPrint webcam on rpi4, small/cheap USB microphones were not sensitive enough, but webcam mic is with ~50% when talking at desk (100% gain in alsamixer)

    echo ">>> Docker"
    # https://docs.docker.com/engine/install/debian/ - version 23.0.1 comes with `docker compose` plugin.
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    sudo usermod -aG docker $USER && newgrp docker # https://stackoverflow.com/questions/48568172/docker-sock-permission-denied
    # ctop - Top-like interface for container metrics - 404 Not Found
      # curl -fsSL https://azlux.fr/repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/azlux-archive-keyring.gpg
      # echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian \
      #   $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azlux.list >/dev/null
      # sudo apt-get update -qq
      # agi docker-ctop
    # lazydocker - Terminal UI for docker and docker-compose
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    # run containers
    source install/docker.sh
  else
    echo "Unknown hostname: $(hostname)! Must be rpi3 or rpi4"
  fi
fi
