#!/usr/bin/env bash
cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy

