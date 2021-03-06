#!/bin/bash

# script to toggle state of trackpads for laptops. Useful for when trackpads are too sensitive to accident
# palm contact if device has poor drivers

# search term to find trackpad input devices
declare -gr TRACKPAD_QUERY=Touchpad 

# optimal device id for disabling trackpad. If not provided then it will be discovered
# interactively based on query term
declare -g DEVICE_ID=

# toggle state of trackpad device
function current_state() {
    xinput list-props $DEVICE_ID | sed -En "s/Device Enabled (\([0-9]*\)):\t([01])/\2/p"
}

if [[ -z $DEVICE_ID ]]; then
    DEVICE_ID=$(xinput --list --name-only | grep $TRACKPAD_QUERY | tr -d '\n' | xargs -r -0 xinput list --id-only)
fi 

if [[ -z $DEVICE_ID ]]; then
    echo "Unable to toggle touchpad. Either the query was bad or the device id wasnt defined."
    exit 1
fi

if [[ $(current_state) -eq 1 ]]; then
    xinput --disable $DEVICE_ID
else
    xinput --enable $DEVICE_ID
fi
