#!/bin/bash

# Get Batocera version
version=$(batocera-es-swissknife --version | awk '{print $1}' | sed -E 's/^([0-9]+).*/\1/')  # Extracts the numeric part

# Compare version and decide which download to trigger
if (( version == 39 || version == 40 )); then
    echo "Batocera version is 39 or 40. Triggering download for version 39/40..."
    sleep 5
    curl -L bit.ly/foclabroc-switchoff-40 | bash
elif (( version == 41 )); then
    echo "Batocera version is 41. Triggering download for version 41+l..."
    sleep 5
 curl -L bit.ly/foclabroc-switchoff | bash
elif (( version == 42 )); then
    echo "Batocera version is 42. Triggering download for version 42..."
    sleep 5
curl -L bit.ly/foclabroc-batswitch | bash
else
    echo "Unknown or unsupported Batocera version: $version"
    dialog --msgbox "Unsupported Batocera version detected: $version. Installation aborted." 8 60
    clear
fi
