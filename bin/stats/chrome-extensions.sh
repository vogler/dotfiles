
for e in ~/Library/Application\ Support/Google/Chrome/Default/Extensions/*/; do
  id=$(basename "$e")
  size=$(du -sh "$e" | cut -f1)
  versions=$(ls "$e" | wc -l)
  latest=$(ls -tr "$e" | tail -1)
  # TODO stat latest for access time and check if opened (lsof?)
  echo "$id $size $versions $latest"
  cat "$e/$latest/manifest.json" | jq .name
  cat "$e/$latest/manifest.json" | jq .browser_action.default_title
  echo
done
