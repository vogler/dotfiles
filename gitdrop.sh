path=~/Dropbox/github
mkdir -p $path
remote=${2-"origin"}
repo=$(git remote show $remote | grep -P -o "github.com/.+$" | uniq | sed 's/github.com\///' | sed 's/\.git$//' | sed 's/\//:/g')
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
            # wait for dropbox to sync
            while true
            do
                stat=`dropbox status`
                echo "dropbox status: $stat"
                if [ "$stat" = "Up to date" ]; then
                    exit
                fi
                sleep 5
            done
            ;;
    *)      echo "usage: save or apply";;
esac;
