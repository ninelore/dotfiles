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
run picom --backend glx --experimental-backends --config ~/.config/picom.conf -b
run nm-applet
run blueman-applet
run flameshot
run parcellite -d
run xset -s 300 5
run xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock

## Workaround for things that dont work with thr un function
sh -c "killall cbatticon"
sh -c "nitrogen --restore"
sh -c "cbatticon -u 20 -c 'systemctl hibernate' -l 15 -r 3 -i symbolic"

## RUN THIS LAST!!!
run pulseaudio --start
