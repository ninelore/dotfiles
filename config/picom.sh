#!/usr/bin/env sh
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	picom --config  ~/.config/picom.conf -b
fi
