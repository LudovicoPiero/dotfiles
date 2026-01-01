#!/usr/bin/env sh

# --- Session Selection ---
SESSION=${1:-dwm}

# --- Helper Functions ---
restart() {
    pkill -u "$USER" -x "$1"
    sleep 0.2
    "$@" &
}

# --- D-Bus Setup ---
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --exit-with-session --sh-syntax)"
fi

# --- Environment & Resources ---
export XCURSOR_THEME=phinger-cursors-light
export XCURSOR_SIZE=24
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# --- Hardware Setup ---
xrandr --output HDMI-A-0 --mode 1920x1080 --rate 180.00 --output eDP --off
xset r rate 300 30

# --- Core Services ---
restart pipewire
restart wireplumber
restart pipewire-pulse
restart dunst
restart fcitx5 -d --replace
restart mpd
restart mpdris2-rs
restart clipmenud

# Backgrounds & Compositor
feh --bg-scale "$HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png" &
picom -b &

# Security
xautolock -time 10 -locker slock &

# XDG Fix
if [ -f "$HOME/.config/dwm/scripts/xdg-portal-fix.sh" ]; then
    "$HOME/.config/dwm/scripts/xdg-portal-fix.sh" &
fi

# --- Window Manager Switcher ---
case $SESSION in
    dwm)
        restart slstatus
        # Smart DWM Loop
        while true; do
            dwm 2> ~/.dwm.log
            # Check for restart signal
            if [ -f "/tmp/dwm.restart" ]; then
                rm -f "/tmp/dwm.restart"
                sleep 1
            else
                break
            fi
        done
        ;;

    bspwm)
        restart sxhkd
        bspwm
        ;;

    i3)
        i3
        ;;

    leftwm)
        leftwm
        ;;

    *)
        echo "Unknown session: $SESSION"
        dwm
        ;;
esac

# --- CLEANUP ---
pkill -u "$USER" -x picom
pkill -u "$USER" -x slstatus
pkill -u "$USER" -x dunst
pkill -u "$USER" -x mpd
pkill -u "$USER" -x pipewire
pkill -u "$USER" -x xautolock
pkill -u "$USER" -x fcitx5
pkill -u "$USER" -x clipmenud

# Exit cleanly
exit 0
