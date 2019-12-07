#!/bin/sh
#
# Write/remove a task to do later.
#
# Select an existing entry to remove it from the file, or type a new entry to
# add it.
#

file="$HOME/.todo"
touch "$file"
height=$(wc -l "$file" | awk '{print $1}')
prompt="Add/delete a task: "

cmd=$(dmenu -l  "$height" -p "$prompt" "$@" < "$file" -sb '#c5c8c6' -sf '#000000' -s 0 -h 20 -i -o 0.80 -fn 'SourceCodePro 12')
while [ -n "$cmd" ]; do
 	if grep -q "^$cmd\$" "$file"; then
		grep -v "^$cmd\$" "$file" > "$file.$$"
		mv "$file.$$" "$file"
        height=$(( height - 1 ))
 	else
		echo "$cmd" >> "$file"
		height=$(( height + 1 ))
 	fi

	cmd=$(dmenu -l  "$height" -p "$prompt" "$@" < "$file" -sb '#c5c8c6' -sf '#000000' -s 0 -h 20 -i -o 0.80 -fn 'SourceCodePro 12')
done

exit 0
