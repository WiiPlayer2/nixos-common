#!/usr/bin/env bash

BASE_DIR="${XDG_DATA_HOME}/work-tracking"
_lastLink="${BASE_DIR}/.last"

debug="${1-true}"
flag=0
work=""
category=""

if [[ "$debug" == "true" ]]; then
  echo "===[ DEBUG ]==="
fi

if [[ -e "$_lastLink" ]]; then
  work=$(jq -r '.description' "$_lastLink")
  category=$(jq -r '.category' "$_lastLink")
fi

while IFS=$'=' read key value; do
  case $key in
    okay)
      flag=1
      ;;
    txtWork)
      work="$value"
      ;;
    lstCategory)
      category="$value"
      ;;
  esac
done < <(
dialogbox <<EOF
add dropdownlist "Category:" lstCategory
add item "" current
end dropdownlist
set lstCategory stylesheet "QComboBox { min-width: 15em; }"

add textbox "&Description:" txtWork "$work"
set txtWork stylesheet "QLineEdit { min-width: 15em; }"

add pushbutton O&k okay apply exit

set "" title "Work Tracking"
set okay default
set txtWork focus
EOF
)

if [ "$flag" == "0" ]; then
  echo "Cancelled."
  exit 1
fi

_timestamp=$(date '+%s')
_humanTimestamp=$(date --date="@$_timestamp" -Iseconds)
_targetFile="${BASE_DIR}/$(date --date="@$_timestamp" '+%Y-%m-%d/%H-%M')"
mkdir -p $(dirname "$_targetFile")
_outData=$(jq -n '{timestamp:$timestamp, humanTimestamp:$humanTimestamp, description:$description, category:$category}' \
  --arg timestamp "$_timestamp" \
  --arg humanTimestamp "$_humanTimestamp" \
  --arg description "$work" \
  --arg category "$category" \
)

if [[ "$debug" != "true" ]]; then
  echo "$_outData" | tee "$_targetFile"
  ln -Tsf "$_targetFile" "$_lastLink"
else
  echo "$_outData"
  echo "Target file: $_targetFile"
  echo "Last link:   $_lastLink"
fi
