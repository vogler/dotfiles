if [[ $(hostname) == "rpi4" ]]; then
  # https://docs.portainer.io/start/install/server/docker/linux
  # Web UI for containers. Requires license! CLI alternatives: ctop, lazydocker
  docker volume create portainer_data
  docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart=unless-stopped --name portainer portainer/portainer-ee:latest

  # https://jellyfin.org/docs/general/installation/container/
  # Using host networking (--net=host) is optional but required in order to use DLNA.
  docker run -d -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache -v /srv/jellyfin/media:/media --net=host --restart=unless-stopped --name=jellyfin jellyfin/jellyfin:latest
fi
