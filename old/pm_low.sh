cpupower frequency-info
cpupower frequency-set -f 800

cat /sys/kernel/debug/dri/0/radeon_pm_info
# echo dynpm > /sys/class/drm/card0/device/power_method # more aggressive, but only single head and also might flicker
# GUI: use power-play-switcher or gnome3-addon to change profile
echo low > /sys/class/drm/card0/device/power_profile
