#!/usr/bin/env bash

function run {
	if ! pgrep -f $1 ;
	then
		$@&
	fi
}

## Place 'run *program* here'. One Program per line
## The function will only start programs that are not running yet
run xrdb -merge $HOME/.Xresources
run lxpolkit
run xlayoutdisplay
run picom --backend glx --experimental-backends --config ~/.config/picom.conf -b
run flameshot
run xset -s 300 5
run xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock

# GPaste Daemon
if ! pgrep -f gpaste-client ;
then
	gpaste-client start
else
	gpaste-client daemon-reexec
fi

## RUN PULSEAUDIO LAST!!!
run pulseaudio --start
