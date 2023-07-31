#!/usr/bin/env bash

# deleted manually without problems:
# 7.01GB ~/Library/Application Support/Google/Chrome/Default/Service Worker/CacheStorage
# 108MB ~/Library/Application Support/Google/Chrome/Default/Service Worker/ScriptCache
# 1.2GB ~/Library/Application Support/Google/Chrome/Default/IndexedDB
# 9.97GB ~/Library/Group Containers/243LU875E5.groups.com.apple.podcasts/Library/Cache
# 354MB ~/Library/Caches/Raspberry\ Pi/Imager/lastdownload.cache

# `brew cleanup` by default only removes downloads older than 120 days
# `brew cleanup --prune=all -n` to show all that would eventually be removed:
# ~/Library/Caches/Homebrew/
# ~/Library/Logs/Homebrew/

# heaviest folders currently are:
# 22.8GB ~/Library/Application Support
# 14.3GB ~/Library/Application Support/Autodesk/webdeploy/production # has 4 versions of Autodesk Fusion 360.app
# 1.3GB  ~/Library/Application Support/Slack/{Service Worker, Cache}
# 1.1GB  ~/Library/Application Support/Microsoft/Teams/{Service Worker, Cache, tmp}
# 15GB   ~/Library/Caches
# 8.2GB  ~/Library/Caches/Homebrew # 5.1GB is the *mactex*.pkg
# 5.1GB  /opt/homebrew/Caskroom/mactex/2023.0314/mactex-20230314.pkg
# https://apple.stackexchange.com/questions/359456/brew-cleanup-doesnt-scrub-the-caskroom
# ls -lahS /opt/homebrew/Caskroom/**/*.pkg # brew maintainers say no, but I guess can be deleted

# existing scripts:
# good set, but just deletes everything: https://gist.github.com/mircobabini/7f944835c44374dd9fe01027e8857e23
# has more stuff, but --dry-run just gives a sum: https://github.com/mac-cleanup/mac-cleanup-sh/blob/main/mac-cleanup
# GUI app, paths: https://github.com/Kevin-De-Koninck/Clean-Me/blob/master/Clean%20Me/Paths.swift

bytesToHuman() {
  b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    let s++
  done
  echo "$b$d ${S[$s]} of space cleaned up"
}

# Check if Time Machine is running
if [ `tmutil status | grep -c "Running = 1"` -ne 0 ]; then
  echo "Time Machine is currently running. Let it finish first!"
  exit
fi

# Check for last Time Machine backup and exit if it's longer than 1 hour ago
lastBackupDateString=`tmutil latestbackup | grep -E -o "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}"`
if [ "$lastBackupDateString" == "" ]; then
  read -n 1 -p "$(tput setaf 3)Last Time Machine backup cannot be found. Proceed anyway?$(tput sgr0) (y/n) " RESP
  echo
  if [ "$RESP" != "y" ]; then
    exit
  fi
else
  lastBackupDate=`date -j -f "%Y-%m-%d-%H%M%S" $lastBackupDateString "+%s"`
  if [ $((`date +%s` - $lastBackupDate)) -gt 3600 ]; then
    printf "Time Machine has not backed up since `date -j -f %s $lastBackupDate` (more than 60 minutes)!"
    exit 1003
  else
    echo "Last Time Machine backup was on `date -j -f %s $lastBackupDate`. "
  fi
fi

# Ask for the administrator password upfront
if [ "$EUID" -ne 0  ]; then
  echo "Please run as root"
  exit
fi

oldAvailable=$(df / | tail -1 | awk '{print $4}')

# TODO

newAvailable=$(df / | tail -1 | awk '{print $4}')
count=$((newAvailable-oldAvailable))
count=$(( $count * 512))
bytesToHuman $count
