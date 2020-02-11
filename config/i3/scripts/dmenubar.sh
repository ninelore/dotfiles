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
	WS=$(python3 -c "import json; print(' '.join('>{}<'.format(_['name']) if _['focused'] else _['name'] for _ in sorted(json.loads('''$(i3-msg -t get_workspaces)'''), key=lambda x: x['num'])))")
	echo "Workspaces: $WS"
}

Spotify(){
	SpNP=$(spotifycli --statusshort)
	echo "Playing: $SpNP"
}

dmenu_run -p "$(Clock) | $(Date) | $(Volume) | $(Spotify) | $(Workspace)" -sb '#c5c8c6' -sf '#000000' -q -s 0 -h 20 -i -o 0.80 -fn 'SourceCodePro 12'

