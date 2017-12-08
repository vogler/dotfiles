key_in=$1
case $key_in in
    j) key_out=Down ;;
    k) key_out=Up ;;
    h) key_out=Left ;;
    l) key_out=Right ;;
esac
WID=`xdotool getactivewindow`
name=$(xprop -id $WID | sed -rn 's/_NET_WM_NAME.*"(.*)"/\1/p')
# notify-send "$name"
if [[ $name == *.pdf\ -\ Google\ Chrome ]]; then
    xdotool key --clearmodifiers --window $WID $key_out
else
    xdotool key --clearmodifiers --window $WID $key_in
fi
