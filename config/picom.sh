#!/usr/bin/env sh
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	picom --backend glx --experimental-backends --config ~/.config/picom.conf -bc
fi
