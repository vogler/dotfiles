if [ `dmesg | grep vbox | wc -l` -gt 0 ]; then
	echo "running inside VirtualBox"
	sudo VBoxService
	VBoxClient-all
	xrandr --auto
else
	echo "running bare metal"
fi
