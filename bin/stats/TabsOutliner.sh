# json=~/Downloads/tree-exported-Fri-Dec-01-2023.tree
json=~/Library/Application\ Support/Google/Chrome/Default/File\ System/000/p/00/00000000

# export is list of arrays, but first element (and some other) was object
# -> need to select arrays first such that all elements have the same type

# also there's no structure, savedwin just inbetween tabs
# beginning of export:
# [
# {
#   "type": 2000,
#   "node": {
#     "type": "session",
#     "data": {
#       "treeId": "1626796724877.1523",
#       "nextDId": 1,
#       "nonDumpedDId": 1
#     }
#   }
# },
# [
#   2001,
#   {
#     "type": "savedwin",
#     "data": {
#       "focused": true,
#       "type": "normal",
#       "rect": "25_732_840_2135"
#     }
#   },
#   [
#     0
#   ]
# ],
# [
#   2001,
#   {
#     "data": {
#       "audible": false,
#       "autoDiscardable": true,
#       "discarded": false,
#       "favIconUrl": "https://www.google.com/favicon.ico",
#       "groupId": -1,
#       "highlighted": true,
#       "mutedInfo": {
#         "muted": false
#       },
#       "title": "Dropbox alternative free - Google Search",
#       "url": "https://www.google.com/search?sxsrf=ALeKk03ClKs3I5Tieig34fCMXu0r1Iqdbg:1626112186064&q=Dropbox+alternative+free&sa=X&ved=2ahUKEwj3kNz5i97xAhUHxIUKHeSkB4AQ1QIwGXoECCYQAQ&biw=1680&bih=946"
#     }
#   },
#   [
#     0,
#     0
#   ]
# ],

# title and url of each tab:
# cat "$json" | jq '.[] | select(.[1]?) | .[1].data | {title, url}'
# cat "$json" | jq '.[] | arrays[1].data | {title, url}'

# echo "Overview (win-1, tab+2, savedwin | null are unloaded)"
# cat "$json" | jq '.[] | arrays[1].type' | sort | uniq -c

# total tabs stats
# not all entries have .url, so we need to select those first before filtering on it:
n=$(cat "$json" | jq '[.[] | arrays[1].data | select(.url)] | length')
echo "$n total tabs"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == null)] | length')
echo "$n saved tabs"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "savedwin")] | length')
echo "$n saved windows"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "win")] | length')
echo "$n active windows"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "tab")] | length')
echo "$n active tabs"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "tab").data | select(.discarded)] | length')
echo "$n active tabs (discarded)"

# mydealz tabs stats
echo
# string: contains, startswith, endswith
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == null).data | select(.url | contains("mydealz.de"))] | length')
echo "$n saved mydealz tabs"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "tab").data | select(.url | contains("mydealz.de"))] | length')
echo "$n active mydealz tabs"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "tab").data | select(.url | contains("mydealz.de/deals/"))] | length')
echo "$n active mydealz deals"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "tab").data | select(.title | contains("mydealz - Deine Nr.1"))] | length')
echo "$n active mydealz start page"
n=$(cat "$json" | jq '[.[] | arrays[1] | select(.type == "tab").data | select(.title | contains("mydealz - Deine Nr.1")) | select(.discarded)] | length')
echo "$n active mydealz start page (discarded)"
