#!/usr/bin/env sh

#echo "Starting jackd..."
#~/bin/startjack

(pgrep mpd > /dev/null && echo "MPD already running") || (echo "Starting mpd...";mpd)

echo "Setting wallpaper..."
nitrogen --restore
#betterlockscreen -w

# echo "Updating cursor theme"
# fix_xcursors

start_service() {
 (pgrep $1 > /dev/null && echo "$1 already running") || (echo "Starting $1"; $2 &)
}

# xbanish make the mouse invisible after a timeout of 2000 ms and while typing
start_service "xbanish" "/usr/bin/xbanish"

# Remap Caps-Lock
echo "Updating keyboard mappings..."
~/bin/remaps

echo "Configuring screensaver..."
# Enable Screen saver
xset dpms 900 900 900
start_service "xautolock" '/usr/bin/xautolock -time 20 -detectsleep -locker "/usr/bin/betterlockscreen -l blur -- -n" -killtime 10 -killer "systemctl suspend"'

start_service "syndaemon" "/usr/bin/syndaemon -i 1 -dkR"
# (pgrep polkit-gnome-au > /dev/null && echo "Gnome Polkit agent already running") || (echo "Starting Gnome Polkit agent";/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &)
start_service "lxsession" "/usr/bin/lxsession -dkR"
start_service "picom" "picom -cCG --experimental-backends"

echo "Starting background applications"
start_service "nm-applet" "nm-applet"
start_service "udiskie" "udiskie -ans -f /usr/bin/pcmanfm"
# start_service "syncthing" "syncthing -no-browser"
# start_service "transmission-da" "transmission-daemon -o -y -b -er -c ~/Downloads -T -w ~/Downloads"
start_service "onedrive" "onedrive --monitor"
start_service "dropbox" "dropbox"
start_service "Enpass" "/opt/enpass/Enpass -minimize"
