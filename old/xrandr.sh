connected=`xrandr -q | grep "DVI-0 connected"`
if [ -n "$connected" ]; then
  echo "DVI-0 is connected!"
  active=`xrandr -q | grep "DVI-0 connected primary 1920"`
  if [ -n "$active" ]; then
    echo "active -> turn off!"
    xrandr --output DVI-0 --off
  else
    echo "not active -> turn on!"
    xrandr --output DVI-0 --right-of LVDS --auto --primary
  fi
else
  echo "DVI-0 is not connected!"
  xrandr --output DVI-0 --off # maybe it wasn't disabled
fi
