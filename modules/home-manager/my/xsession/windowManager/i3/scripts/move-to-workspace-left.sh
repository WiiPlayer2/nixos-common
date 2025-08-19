#!/usr/bin/env sh
CURRENT_WORKSPACE=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).num')
NEXT_WORKSPACE=$((CURRENT_WORKSPACE-1))
if (( NEXT_WORKSPACE < 1 )); then
  NEXT_WORKSPACE=10
fi
i3-msg move container to workspace number $NEXT_WORKSPACE
i3-msg workspace number $NEXT_WORKSPACE