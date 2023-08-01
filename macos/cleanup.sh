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

# heaviest folders to clean:
# 40.7GB ~/Library/Application Support
# 19.2GB ~/Library/Application Support/Google/Chrome
# 9.69GB ~/Library/Application Support/Google/Chrome/Default/File System
# 7.02GB ~/Library/Application Support/Google/Chrome/Default/Service Worker
# 1.2GB  ~/Library/Application Support/Google/Chrome/Default/IndexedDB
# 14.3GB ~/Library/Application Support/Autodesk/webdeploy/production # has 4 versions of Autodesk Fusion 360.app
# 1.3GB  ~/Library/Application Support/Slack/{Service Worker,Cache}
# 1.1GB  ~/Library/Application Support/Microsoft/Teams/{Service Worker,Cache,tmp}
# 15GB   ~/Library/Caches
# 8.2GB  ~/Library/Caches/Homebrew # 5.1GB is the *mactex*.pkg
# 5.1GB  /opt/homebrew/Caskroom/mactex/2023.0314/mactex-20230314.pkg
# https://apple.stackexchange.com/questions/359456/brew-cleanup-doesnt-scrub-the-caskroom
# ls -lahS /opt/homebrew/Caskroom/**/*.pkg # brew maintainers say no, but I guess can be deleted
# 9.97GB ~/Library/Group Containers/243LU875E5.groups.com.apple.podcasts/Library/Cache # automatic downloads disabled and deleted

# existing apps/scripts:
# GUI app, paths: https://github.com/Kevin-De-Koninck/Clean-Me/blob/master/Clean%20Me/Paths.swift
# good set, but just deletes everything: https://gist.github.com/mircobabini/7f944835c44374dd9fe01027e8857e23
# has more stuff, but --dry-run just gives a sum: https://github.com/mac-cleanup/mac-cleanup-sh/blob/main/mac-cleanup
# modular implementation in python but still need to check each module for size since --dry-run will just show sum of all activated modules: https://github.com/mac-cleanup/mac-cleanup-py

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-c] [-d] [-e] [-p] [-t] [-h] [-v]

-c, --checks     Check for last time machine backup, sudo etc.
-d, --dry-run    Just report, but don't delete anything.
-e, --empty      Also report and delete empty directories.
-p, --prompt     Prompt whether to delete for each entry.
-t, --trash      Move folders to the trash instead of deleting them with rm. May ask for permission.

-h, --help       Print this usage information.
-v, --verbose    Enable verbose output.
EOF
  exit
}

parse_params() {
  while :; do
    case "${1-}" in
    -c | --checks) checks=true ;;
    -d | --dry-run) dry_run=true ;;
    -e | --empty) empty=true ;;
    -p | --prompt) prompt=true ;;
    -t | --trash) use_trash=true ;;
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done
  return 0
}

parse_params "$@"

bytesToHuman() {
  b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    let s++
  done
  echo "$b$d ${S[$s]} of space cleaned up"
}

has(){ # check if a command is available
  hash "$1" 2>/dev/null
}

trash() {
  # https://apple.stackexchange.com/questions/50844/how-to-move-files-to-trash-from-command-line
  # `brew install trash` verison did not have `Put Back` in context menu of deleted files
  # https://github.com/morgant/tools-osx/blob/71c2db389c48cee8d03931eeb083cfc68158f7ed/src/trash#L307C2-L307C2
  for f in $@; do
    osascript -e "tell application \"Finder\" to delete POSIX file \"$(realpath $f)\"" > /dev/null
  done
}

clean() {
  space=$(du -sh "$@" 2> /dev/null)
  nonempty=$(echo "$space" | grep -v "^0")
  if [ $empty ]; then
    echo "$space"
  else
    if [ -z "$nonempty" ]; then
      # echo "empty: $@"
      return
    else
      echo "$nonempty"
    fi
  fi
  if [ $prompt ]; then
    read -n1 -s -r -p $'Delete? (y/n)\n' key
    if [ "$key" != 'y' ]; then
      return
    fi
  fi
  if [ -z $dry_run ]; then
    if [ -z $use_trash ]; then
      rm -rfv "$@"
    else
      trash "$@"
      echo "trashed '$@'"
    fi
  fi
}

if [ $checks ]; then
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
fi

oldAvailable=$(df / | tail -1 | awk '{print $4}')

# echo "> Trash"
# clean /Volumes/*/.Trashes
# clean ~/.Trash # du: cannot read directory; only works if you give a path to something in the trash
echo "> Temporary files"
clean /tmp/*
clean /private/var/tmp/Processing/
clean /private/var/tmp/Xcode/
clean /private/var/tmp/tmp*
echo "> Log files"
clean /var/log/
clean /private/var/log/
clean /Library/Logs/
clean ~/Library/Logs/
clean ~/Library/Containers/*/Data/Library/Logs
echo "> Caches"
clean /Library/Caches
clean ~/Library/Caches
clean ~/Library/Containers/*/Data/Library/Caches
echo "> Caches (Application-specific)" # TODO check that apps are not running?
clean ~/Library/Application\ Support/Google/Chrome/Default/{File\ System,Service\ Worker,IndexedDB}
clean ~/Library/Application\ Support/Slack/{Service\ Worker,Cache}
clean ~/Library/Application\ Support/Microsoft/Teams/{Service\ Worker,Cache,tmp}

if [ -z $dry_run ]; then
  echo "> dev pkg cache clean" # TODO just use paths as above?
  has gem && gem cleanup
  has npm && npm cache clean --force
  has yarn && yarn cache clean
  # has docker && docker system prune -f # -a removes all images, not just dangling ones
  # echo "> Postprocessing"
  # brew tap --repair # TODO needed?
fi

echo
newAvailable=$(df / | tail -1 | awk '{print $4}')
count=$((newAvailable-oldAvailable))
count=$(( $count * 512))
bytesToHuman $count
