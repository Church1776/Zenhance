function select_backward_word() {
	if (( ! REGION_ACTIVE )); then
		zle set-mark-command
	fi
	zle backward-word
}