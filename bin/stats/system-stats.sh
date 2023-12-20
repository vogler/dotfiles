# `top` summary includes info about processes, time, load, memory, swap, network, disk
# sed: delete date (2nd line) and some stats we don't care about
top -l 1 -S | head -n 12 | sed '2d; /SharedLibs/d; /MemRegions/d; /Purgeable/d'
# echo

# vm_stat # Virtual Memory Statistics

# sysctl vm.loadavg # {1, 5, 15} min
# vm.loadavg: { 1.32 1.83 2.03 }

# top -l 1 | grep PhysMem
sysctl vm.swapusage
# vm.swapusage: total = 16384.00M  used = 15655.94M  free = 728.06M  (encrypted)

# free space on SSD
# df --output=avail .
# this showed 15GB, `df -H` 17, iStat Menus 17.9, Finder 19.03, Settings 19.52
# this is GNU df, /bin/df is macOS and a bit different but /bin/df -h also showed 15GB and -H 16GB
n=$(df -H --output=avail . | tail -n 1 | xargs)
echo "${n}B free SSD (df)"
n=$(diskutil info / | grep Free | grep -oP "\d+(\.\d+)? \w+" | head -n 1 | sed 's/ //')
# diskutil showed 16.1GB (already /1000 like df -H)
echo "${n} free SSD (diskutil)"

uptime
