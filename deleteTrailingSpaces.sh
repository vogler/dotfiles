name=${1-"*.ml"}
path=${2-"."}
find "$path" -name "$name" -type f -print0 | xargs -0 sed -i 's/[ \t]*$//'
# find "$path" -name "$name" -type f -print0 | xargs -0 echo
