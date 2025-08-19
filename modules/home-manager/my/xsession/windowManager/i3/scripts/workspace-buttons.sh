#!/usr/bin/env
i3-msg -t subscribe -m '["workspace", "output"]' | {
    # Initially print the current workspaces before we receive any events. This
    # avoids having an empty bar when starting up.
    i3-msg -t get_workspaces;
    # Then, while we receive events, update the workspace information.
    while read EVENT; do i3-msg -t get_workspaces; done;
}