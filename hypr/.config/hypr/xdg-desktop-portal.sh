#!/usr/bin/env bash

sleep 1
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-gnome
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal-gtk
killall xdg-desktop-portal

logger 'killed all xdg-desktop'

sleep 1
/usr/lib/xdg-desktop-portal-gtk &
logger 'xdg-desktop-portal-gtk started'

sleep 1
/usr/lib/xdg-desktop-portal-hyprland &
logger 'xdg-desktop-portal-hyprland started'

sleep 2
/usr/lib/xdg-desktop-portal &
logger 'xdg-desktop-portal started'
