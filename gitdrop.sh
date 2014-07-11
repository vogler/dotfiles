path=~/Dropbox/github
mkdir -p $path
repo=$(git remote show origin | grep -P -o "[^/]+/[^/]+$" | uniq | sed 's/\.git$//' | sed 's/\//:/g')
branch=$(git branch | grep "*" | cut -c3-)
file=$path/$repo:$branch.diff
case $1 in
    apply)  if [ -f $file ]; then
                git apply $file
            else
                echo "$file does not exist!"
            fi
            ;;
    diff|save)
            git reset . # unstage everything
            git add -N . # --intend-to-add: this makes untracked files appear in the diff
            git diff > $file
            git reset . # unstage intend-to-add files again (otherwise stash won't work)
            echo "diff saved to $file"
            ;;
    *)      echo "usage: save or apply";;
esac;
