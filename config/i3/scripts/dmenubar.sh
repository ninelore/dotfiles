#!/bin/bash/

Clock(){
	date "+%H:%M"
}

Date(){
	date "+%d.%m.%Y"
}

Volume(){
	vol=$(pamixer --get-volume-human)
	echo "Volume: $vol"
}

Workspace(){
	WS=$(python3 -c "import json; print(next(filter(lambda w: w['focused'], json.loads('$(i3-msg -t get_workspaces)')))['num'])")
	echo "Workspace: $WS"
}

dmenu_run -p "$(Clock) | $(Date) | $(Volume)" -sb '#c5c8c6' -sf '#000000' -q -s 0 -h 20 -i -o 0.80 -fn 'SourceCodePro 12'

