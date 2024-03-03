#!/usr/bin/env zsh

# bash does not care if glob expr doesn't give any matches, but zsh gives error 'zsh: no matches found: ...'; https://unix.stackexchange.com/questions/310540/how-to-get-rid-of-no-match-found-when-running-rm
# setopt +o nullglob # delete patterns which don’t match anything
setopt +o nomatch # leave globbing expressions which don't match anything as-is

# examples for heavy folders that can be cleaned up:
# 50.9GB ~/Library/Application Support
# 19.2GB ~/Library/Application Support/Google/Chrome
# 9.69GB ~/Library/Application Support/Google/Chrome/Default/File System
# 7.02GB ~/Library/Application Support/Google/Chrome/Default/Service Worker
# 1.2GB  ~/Library/Application Support/Google/Chrome/Default/IndexedDB
# 24.5GB ~/Library/Application Support/Autodesk/webdeploy/production # has 5 versions of Autodesk Fusion 360.app
# 1.3GB  ~/Library/Application Support/Slack/{Service Worker,Cache}
# 1.1GB  ~/Library/Application Support/Microsoft/Teams/{Service Worker,Cache,tmp}
# 15GB   ~/Library/Caches
# 8.2GB  ~/Library/Caches/Homebrew # 5.1GB is the *mactex*.pkg
# 5.1GB  /opt/homebrew/Caskroom/mactex/2023.0314/mactex-20230314.pkg
# https://apple.stackexchange.com/questions/359456/brew-cleanup-doesnt-scrub-the-caskroom
# ls -lahS /opt/homebrew/Caskroom/**/*.pkg # brew maintainers say no, but I guess can be deleted
# 9.97GB ~/Library/Group Containers/243LU875E5.groups.com.apple.podcasts/Library/Cache # automatic downloads disabled and deleted

# `brew cleanup` by default only removes downloads older than 120 days
# `brew cleanup --prune=all -n` to show all that would eventually be removed:
# ~/Library/Caches/Homebrew/
# ~/Library/Logs/Homebrew/

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
  # `brew install trash` version did not have `Put Back` in context menu of deleted files
  # https://github.com/morgant/tools-osx/blob/71c2db389c48cee8d03931eeb083cfc68158f7ed/src/trash#L307C2-L307C2
  for f in "$@"; do
    p=$(realpath "$f")
    osascript -e "tell application \"Finder\" to delete POSIX file \"$p\"" > /dev/null
  done
}

clean() {
  # if [[ -z "${@// }" ]]; then echo "no match: $@"; return; fi
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
  # stat "$@" # to note Access, Uid, Gid
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
# /tmp -> private/tmp
clean /private/tmp/* 
clean /private/var/tmp/Processing/
clean /private/var/tmp/Xcode/
clean /private/var/tmp/tmp*
echo "> Log files"
# /var -> private/var
# clean /private/var/log/ # drwxr-xr-x root wheel; recreated with group admin instead of wheel; small but will be nonempty fast
clean /Library/Logs/ # drwxr-xr-x root wheel
# all the folders in ~/Library are 0700/drwx------+ $USER:staff unless specified otherwise
clean ~/Library/Logs/
clean ~/Library/Containers/*/Data/Library/Logs
echo "> Caches"
# clean /Library/Caches # 1777/drwxrwxrwt root admin; DO NOT DELETE! Deleted com.apple.aned and then had to skip it every time on 'Empty Trash' until I booted into recovery mode to `rm -f` it (no way to delete/move it otherwise).
# 390MB /Library/Caches/com.apple.iconservices.store; rest is <1MB or no access
clean ~/Library/Caches
clean ~/Library/Containers/*/Data/Library/Caches
echo "> Caches (Application-specific)" # TODO check that apps are not running?
clean ~/Library/Application\ Support/Google/Chrome/Default/{File\ System,Service\ Worker,IndexedDB} # only issues noted: web.whatsapp.com need to link device again
# TODO Chrome extensions keep around old versions after update; total du was 5.4GB
# e.g. ~/Library/Application\ Support/Google/Chrome/Default/Extensions/cjpalhdlnbpafiamejdnhcphjbkeiagm/ (uBlock) is 2.12GB while the latest version 1.54.0_0 is only 14.27MB; SponsorBlock is 1.3GB; React Developer Tools is 1.1GB -> manually deleted old versions for now (which made uBlock lose its settings since it was apparently still using an old version while the new one was already installed?!, uBlock only switched from 1.54.0 to 1.55.0 after I disabled/reenabled the extension)
# extended https://stackoverflow.com/questions/17141917/chrome-keeps-all-versions-of-my-hosted-app-extension-takes-up-mbs-how-tell-i
for i in ~/Library/Application\ Support/Google/Chrome/Default/Extensions/*(/); do
  if [[ ${#$(ls -1 $i)} -gt 2 ]]; then # >=3 versions exist
    # rm -r $i/*^(Om[1,-2]) # deletes all but the first (0 sorts in desc order by m (modification time)), requires extendedglob
    echo $i
    cat $i/$(ls $i | tail -1)/manifest.json | jq '{name, version}' # TODO last version may not be the currently used one
    for j in $(ls -t $i | tail -n +3); do # delete all but the last 2 modified versions
      clean $i/$j
    done
    echo
  fi
done
clean ~/Library/Application\ Support/Slack/{Service\ Worker,Cache}
# old Teams
clean ~/Library/Application\ Support/Microsoft/Teams/{Service\ Worker,Cache,tmp} # tmp is 0755/drwxr-xr-x
# new Teams 'Microsoft Teams (work or school)'
clean ~/Library/Containers/com.microsoft.teams2/Data/Library/Application\ Support/Microsoft/MSTeams/EBWebView/*Profile*/{Service\ Worker,WebStorage} # was ~2.7GB
clean ~/Library/Application\ Support/zoom.us/AutoUpdater/Zoom.pkg # ~87MB, will be downloaded on update
clean ~/Library/Application\ Support/Code/CachedExtensionVSIXs # ~372MB, will refill on extension updates
clean ~/Library/Application\ Support/Code/CachedData # 298MB, 38MB after restart of workspace
# https://github.com/niklasberglund/xcode-clean.sh
clean ~/Library/Developer/Xcode/{Archives,DerivedData,DocumentationCache}
clean ~/Library/Developer/CoreSimulator/{Caches,Devices}

! has podman && [ -d ~/.local/share/containers/podman ] && clean ~/.local/share/containers/podman # leftover ~5GB qemu machine after `brew uninstall --zap podman`

# Autodesk Fusion 360 kept old versions of the app (25GB) while the current one was 7.8GB; can just delete old ones
if [ -d ~/Library/Application\ Support/Autodesk/webdeploy/production ]; then
  echo "> Old versions of Autodesk Fusion 360"
  echo "All versions:"
  du -sh ~/Library/Application\ Support/Autodesk/webdeploy/production
  current=$(readlink -f /Users/voglerr/Library/Application\ Support/Autodesk/webdeploy/production/Autodesk\ Fusion\ 360.app)
  echo "Current version:"
  du -sh "$current"
  # c=$(echo "$current" | sed 's#.*/production/\(.*\)/.*#\1#')
  c=$(dirname "$current")
  for d in ~/Library/Application\ Support/Autodesk/webdeploy/production/*/; do
    # skip anything that doesn't have the .app inside
    if [ ! -d "$d/Autodesk Fusion 360.app" ]; then continue; fi
    if [ "$d" = "$c/" ]; then
      echo "Will not delete current version: $d"
    else
      clean "$d"
    fi
  done
fi

if [ -z $dry_run ]; then
  echo "> pkg cache clean" # TODO just use paths as above?
  # has brew && brew cleanup --prune=all # this will only delete downloads in ~/Library/Caches/Homebrew which is already deleted above
  has gem && gem cleanup
  has npm && npm cache clean --force
  has yarn && yarn cache clean
  # has docker && docker system prune -f # -a removes all images, not just dangling ones
  # echo "> Postprocessing"
  # brew tap --repair # TODO needed?
fi
# System Settings > Login Items
# ls /Library/{LaunchAgents,LaunchDaemons} ~/Library/LaunchAgents # usually just disable them in the UI, but may want to delete some leftover items of uninstalled apps (happened with Keybase)

echo
newAvailable=$(df / | tail -1 | awk '{print $4}')
count=$((newAvailable-oldAvailable))
count=$(( $count * 512))
bytesToHuman $count
