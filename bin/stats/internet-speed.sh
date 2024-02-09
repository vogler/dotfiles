# This will run a speedtest and append the results to a Google Sheet.
# Run this as a cronjob to e.g. sample speeds for cable connections at different times. DSL is pretty stable.
# For adhoc tests, just run `speedtest`.

# The spreadsheet uses the following columns:
# Date	ISP	Device	Down (MBit/s)	Up (MBit/s)	Ping idle latency (ms)	Test server	Result link

# Uses the following:
# - https://www.speedtest.net/apps/cli for the speed test
# - https://jqlang.github.io/jq for easily picking the results
# - https://github.com/jroehl/google-sheet-cli for appending the results to a Google Sheet

CONFIG=${CONFIG-'~/.google-sheet-cli.env'} # check permissions!
# You can also put those in $CONFIG together with the credentials to override them below.
SPREADSHEETID=${SPREADSHEETID-'1jNoVcIZWWriQYGJZOWhcRwhwURWWUpyGyjh0QY4buQ8'}
WORKSHEETTITLE=${WORKSHEETTITLE-'Sheet1'}
ISP=${ISP-'PYUR'} # This is just a constant for your ISP that you are testing with. Compared m-net FTTB DSL 100MBit/s with PYUR FTTB Cable 1GBit/s.

has(){ # check if a command is available
  hash "$1" 2>/dev/null
}

if ! has speedtest; then
  echo "Please install speedtest: https://www.speedtest.net/apps/cli"
  exit 1
fi
if ! has jq; then
  echo "Please install jq: https://jqlang.github.io/jq"
  exit 1
fi

# load credentials $GSHEET_CLIENT_EMAIL and $GSHEET_PRIVATE_KEY if not set
if [[ -z $GSHEET_CLIENT_EMAIL || -z $GSHEET_PRIVATE_KEY ]]; then
  if [ -f "$CONFIG" ]; then
    set -a && source "$CONFIG" && set +a
    echo "Loaded credentials."
  else
    echo "Credentials are not set and $CONFIG does not exist!"
    echo "See https://github.com/jroehl/google-sheet-cli for how to set up credentials."
    echo "After, you can put GSHEET_CLIENT_EMAIL and GSHEET_PRIVATE_KEY in $CONFIG or set them via direnv or similar tools."
    echo "Without credentials set, google-sheet-cli will still work, but prompt you for them interactively."
  fi
fi

STARTTIME=$(date --rfc-3339=seconds)
echo "Starting test at $STARTTIME"
# fast testing: `speedtest -f json > speedtest.json`
RESULT=$([ -f speedtest.json ] && cat speedtest.json || speedtest -f json)
RESULTTIME=$(echo "$RESULT" | jq .timestamp)
DEVICE=$(hostname -s)
# Bandwidth is in bytes/s, so we convert it to MBit/s and round to two decimal places.
DOWN=$(echo "$RESULT" | jq '.download.bandwidth*8/1024/1024*100|round/100')
UP=$(echo "$RESULT" | jq '.upload.bandwidth*8/1024/1024*100|round/100')
PING=$(echo "$RESULT" | jq '.ping.latency*10|round/10') # rounded to one decimal place
SERVER=$(echo "$RESULT" | jq .isp)
URL=$(echo "$RESULT" | jq .result.url)
ROW="[[\"$STARTTIME\", \"$ISP\", \"$DEVICE\", $DOWN, $UP, $PING, $SERVER, $URL]]"
echo $ROW
npx google-sheet-cli data:append --spreadsheetId="$SPREADSHEETID" --worksheetTitle="$WORKSHEETTITLE" "$ROW"
