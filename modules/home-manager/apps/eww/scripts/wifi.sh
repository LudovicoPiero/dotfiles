#!/bin/sh

if nmcli n | grep -q "enabled"; then
    icon=""
    ssid=AUSSIE
    status="Connected to ${ssid}"
else
    icon="睊"
    status="Offline"
fi

echo "{\"icon\": \"${icon}\", \"status\": \"${status}\"}" 
