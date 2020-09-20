#!/usr/bin/env sh

echo "Starting jackd..."
~/bin/startjack

(pgrep mpd > /dev/null && echo "MPD already running") || (echo "Starting mpd...";mpd)

echo "Setting wallpaper..."
betterlockscreen -w


echo "Updating cursor theme"
fix_xcursors

# xbanish make the mouse invisible after a timeout of 2000 ms and while typing
(pgrep xbanish > /dev/null && echo "xbanish already running") || (echo "starting xbanish";xbanish -bt 2000)

# Remap Caps-Lock
echo "Updating keyboard mappings..."
~/bin/remaps

echo "Configuring screensaver..."
# Enable Screen saver
xset dpms 900 900 900
pgrep xautolock > /dev/null || xautolock -detectsleep &

(pgrep polkit-gnome-au > /dev/null && echo "Gnome Polkit agent already running") || (echo "Starting Gnome Polkit agent";/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &)
(pgrep picom > /dev/null && echo "Picom already running") || (echo "Starting Picom";~/bin/toggle_picom)

echo "Starting background applications"
pgrep nm-applet > /dev/null || nm-applet &
pgrep udiskie > /dev/null || udiskie -ans -f /usr/bin/pcmanfm &
pgrep syncthing > /dev/null || syncthing -no-browser &
pgrep transmission-da > /dev/null || transmission-daemon -o -y -b -er -c ~/Downloads -T -w ~/Downloads
pgrep onedrive > /dev/null || onedrive -m &
pgrep dropbox > /dev/null || dropbox &
pgrep Enpass > /dev/null || /opt/enpass/Enpass -minimize
pgrep xfce4-power-man > /dev/null || xfce4-power-manager

