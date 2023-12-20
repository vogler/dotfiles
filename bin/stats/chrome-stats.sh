# Chrome memory usage?
# Tabs using the most memory: chrome://system/#mem_usage_with_title
# Tabs Outliner at the top with 2275MB

# ps outputs memory in KB
# ps aux | grep 'Google Chrome' | grep -v grep | awk '{m=$5; sum+=m} END {print "Total VSZ: " sum}'
# Total VSZ: 65857572064 # 61.33TB virtual memory (reserved, memory mapped files etc.)...
# ps aux | grep 'Google Chrome' | grep -v grep | awk '{m=$6; sum+=m} END {print "Total RSS: " sum}'
# Total RSS: 2267552 # 2.16GB physical memory

# https://stackoverflow.com/questions/131303/how-can-i-measure-the-actual-memory-usage-of-an-application-or-process
# -> VSZ reported by ps is not useful, want USS (unique set size) or PSS (proportional set size)

# iStat Menus reports 20.7GB memory usage for Chrome

function vmuse() {
  vmmap -summary "$1" 2>/dev/null | grep --color=never -E '^Process:|^Version:|Launch Time:|Physical footprint|VIRTUAL|REGION TYPE|TOTAL ' | head -n -2
}
vmuse 'Google Chrome' # 2.1G physical, 36G virtual
echo
vmuse 'Google Chrome Helper (GPU)' # 5G physical, 36G virtual
