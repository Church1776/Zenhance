function select_forward_char() {
	if (( ! REGION_ACTIVE )); then
		zle set-mark-command
	fi
	zle forward-char
}