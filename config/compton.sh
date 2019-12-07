#!/usr/bin/env sh
if pgrep -x "compton" > /dev/null
then
	killall compton
else
	compton --config  ~/.config/compton.conf -b
fi
