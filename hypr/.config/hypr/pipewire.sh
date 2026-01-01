#!/usr/bin/env bash

# Kill any existing pipewire/wireplumber processes
pkill -u "$USER" -x pipewire
pkill -u "$USER" -x wireplumber
pkill -u "$USER" -x pipewire-pulse

# Wait a moment for them to die
sleep 1

# Start the Gentoo launcher
gentoo-pipewire-launcher &
