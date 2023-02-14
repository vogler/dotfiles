if [[ $(hostname) == "rpi4" ]]; then
  # Portainer: Web UI for container management. Requires license! CLI alternatives: ctop, lazydocker.
  # https://github.com/portainer/portainer/
  # https://docs.portainer.io/start/install/server/docker/linux
  docker volume create portainer_data
  docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart=unless-stopped --name portainer portainer/portainer-ee:latest

  # Jellyfin: Media server with clients for browser, Fire TV etc.
  # https://github.com/jellyfin/jellyfin
  # https://jellyfin.org/docs/general/installation/container/
  # Using host networking (--net=host) is optional but required in order to use DLNA.
  docker run -d -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache -v /srv/jellyfin/media:/media --net=host --restart=unless-stopped --name=jellyfin jellyfin/jellyfin:latest

  # Uptime Kuma: Monitoring uptime for HTTP, keywords, TCP ports, ping, DNS; notifications for Telegram, Slack etc.
  # https://github.com/louislam/uptime-kuma
  docker run -d -p 3001:3001 -v uptime-kuma:/app/data --restart=unless-stopped --name uptime-kuma louislam/uptime-kuma:1
fi
