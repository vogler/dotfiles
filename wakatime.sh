#!/bin/bash

# https://wakatime.com/terminal Installing for zsh (with project detection)
sudo pip3 install wakatime
if grep --quiet 'api_key=.' ~/.wakatime.cfg; then
  echo "WakaTime API-key already configured."
else
  echo
  echo "Please input your secret API-key for WakaTime."
  echo "See https://wakatime.com/settings/api-key"
  read -p 'API-key: ' key
  echo -e "[settings]\napi_key=$key" >> ~/.wakatime.cfg
fi
mkdir -p ~/.wakatime
chmod 700 ~/.wakatime
