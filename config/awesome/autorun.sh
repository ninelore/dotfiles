#!/bin/bash

function run {
	if ! pgrep -f $1 ;
	then
		$@&
	fi
}

## Place 'run *program* here'. One Program per line
## The function will only start programs that are not running yet
run xrdb -merge $HOME/.Xresources
run pulseaudio --start
run lxpolkit
run nitrogen --restore
run picom --backend glx --experimental-backends --config ~/.config/picom.conf -b
run nm-applet
run blueman-applet
run cbatticon -u 20 -c "systemctl hibernate" -l 15 -r 3 -i symbolic
run flameshot
run parcellite -d
run xset -s 300 5
run xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock
