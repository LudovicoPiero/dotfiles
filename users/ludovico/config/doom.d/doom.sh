#!/usr/bin/env sh

DOOM="$HOME/.emacs.d"

if [ ! -d "$DOOM" ]; then
  git clone https://github.com/hlissner/doom-emacs.git $DOOM
  yes | $DOOM/bin/doom install
else
  $DOOM/bin/doom sync
fi

if pgrep -x "emacs" > /dev/null
then
    systemctl --user daemon-reload
    systemctl --user restart emacs.service
else
    systemctl --user start emacs.service
fi
