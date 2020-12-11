#!/usr/bin/env sh

echo "Setting wallpaper..."
betterlockscreen -w

echo "Starting jackd..."
~/bin/startjack

(pgrep mpd > /dev/null && echo "MPD already running") || (echo "Starting mpd..."; mpd &)

echo "Updating cursor theme"
fix_xcursors

# xbanish make the mouse invisible after a timeout of 2000 ms and while typing
(pgrep xbanish > /dev/null && echo "xbanish already running") || (echo "starting xbanish";xbanish -bt 2000)

# Remap Caps-Lock
echo "Updating keyboard mappings..."
~/bin/remaps

#echo "Configuring screensaver..."
 Enable Screen saver
xset dpms 900 900 900
(pgrep xautolock > /dev/null) || (xautolock -detectsleep &)

(pgrep polkit-gnome-au > /dev/null && echo "Gnome Polkit agent already running") || (echo "Starting Gnome Polkit agent";/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &)
(pgrep picom > /dev/null && echo "Picom already running") || (echo "Starting Picom";~/bin/toggle_picom)

echo "Starting background applications"
(pgrep trayer > /dev/null) || (trayer --edge top --align right --widthtype request --padding 5 --margin 0 --iconspacing 5 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --tint 0x2e3440 --height 26 &)
(pgrep nm-applet > /dev/null) || (nm-applet &)
(pgrep udiskie > /dev/null) || (udiskie -ans -f /usr/bin/pcmanfm &)
## pgrep syncthing > /dev/null || syncthing -no-browser &
## pgrep transmission-da > /dev/null || transmission-daemon -o -y -b -er -c ~/Downloads -T -w ~/Downloads
(pgrep onedrive > /dev/null) || (onedrive -m &)
(pgrep dropbox > /dev/null) || (dropbox &)
(pgrep Enpass > /dev/null) || (/opt/enpass/Enpass -minimize &)
(pgrep xfce4-power-man > /dev/null) || (xfce4-power-manager &)

