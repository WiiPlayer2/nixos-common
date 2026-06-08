#!/usr/bin/env bash

flag=0
work=""

while IFS=$'=' read key value; do
  case $key in
    okay)
      flag=1
      ;;
    txtWork)
      work="$value"
      ;;
  esac
done < <(
dialogbox <<EOF
add frame horizontal
add stretch
add textbox "&Current work:" txtWork ""
add stretch
add pushbutton O&k okay apply exit
end frame
set okay default
set txt1 focus
EOF
)

if [ "$flag" == "0" ]; then
  echo "Cancelled."
  exit 1
fi

echo "$work"
_timestamp=$(date '+%Y-%m-%d/%H-%M')
_targetFile="${XDG_DATA_HOME}/work-tracking/$_timestamp"
mkdir -p $(dirname "$_targetFile")
echo "$work" > "$_targetFile"
