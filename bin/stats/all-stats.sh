date --rfc-3339=seconds

d=$(dirname "$0")
. "$d/system-stats.sh"
echo
. "$d/chrome-stats.sh"
echo
. "$d/TabsOutliner.sh"
