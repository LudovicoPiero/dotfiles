#!/usr/bin/env sh

home-manager switch --flake .#ludovico
pkill waybar
sleep 1
waybar & disown
