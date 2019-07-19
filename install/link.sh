#!/bin/bash

BASEDIR="$(cd "$(dirname "$0")/.."; pwd)";
echo ">> Find *.symlink in $BASEDIR"

tolink=$( find -H "$BASEDIR" -name '*.symlink' )
for file in $tolink ; do
    target=$(echo $file | sed 's/\.symlink$//' | sed 's/\/dotfiles//') # remove /dotfiles from the absolute path -> root is parent of /dotfiles -> problem if /dotfiles is not placed directly into ~
    echo "ln -s $file $target"
    mkdir -p $(dirname $target)
    ln -sf $file $target
done
