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
            git add . # add everything (including untracked files) to the index
            git diff --cached > $file
            git reset . # unstage files again
            echo "diff saved to $file"
            ;;
    *)      echo "usage: save or apply";;
esac;
