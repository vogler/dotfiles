# For benchmark of startup time see README.md

# 06.02.24 - coc.nvim spawns many node processes
# Activity Monitor shows 64h of CPU time for iTerm2 and only 59h for Chrome...
# Switched view to hierarchical, but there's no column that sums up CPU Time for parent, so it's hard to find out where most of it went.
# Switched back to normal view. Seems like it's really just iTerm2: it spawned many zsh, nvim, node, python, but the highest CPU Time was for a node process was 31m with the rest being <1m.
# So CPU Time not really a problem.
# However there are a lot of node processes spawned by coc.nvim, probably by coc-tsserver.
# Compare the following:
procs nvim | wc  -l
# 41
procs node | wc  -l
# 44
procs node | grep coc | wc -l
# 42
procs nvim | grep coc | wc -l
# 23
# Highest memory usage (RSS) of top node process was 39MB in Activity Monitor, most <1MB. Not that bad, but would be nicer if they could be shared.
procs -i VmRss --sortd VmRss node
# Somehow here the top two processes only had (16+9)MB.
ps aux | grep node | grep -v grep | awk '{m=$6; sum+=m} END {print "Total RSS in KB: " sum}'
# ~88MB in total
