function select_backward_char() {
	if (( ! REGION_ACTIVE )); then
		zle set-mark-command
	fi
	zle backward-char
}