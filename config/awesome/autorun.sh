#!/usr/bin/env bash

function run {
	if ! pgrep -f $1 ;
	then
		$@&
	fi
}

#### This file is for system background programs!
## Place 'run *program* here'. One Program per line
## The function will only start programs that are not running yet
run xrdb -merge $HOME/.Xresources
run lxpolkit
run xlayoutdisplay
run picom --backend glx --experimental-backends --config ~/.config/picom.conf -b
run light-locker
run flameshot
run xset s 300 5
run xss-lock -n /usr/lib/xsecurelock/dimmer -l -- light-locker-command -l
numlockx on

# run .fehbg if it exists
if [[ -e $HOME/.fehbg ]]; then
	$HOME/.fehbg
fi

# GPaste Daemon
if ! pgrep -f gpaste-client ;
then
	gpaste-client start
else
	gpaste-client daemon-reexec
fi

## start Pulseaudio as late as possible if installed
if [[ -e /usr/bin/pulseaudio ]]; then
	run pulseaudio --start
fi

# run additional programs that arent system
if [[ -e $HOME/.config/autorun.sh ]]; then
	sleep 1
	$HOME/.config/autorun.sh
fi

