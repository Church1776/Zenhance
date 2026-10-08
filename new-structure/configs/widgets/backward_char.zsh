function backward_char() {
	if (( REGION_ACTIVE )); then
		if (( CURSOR > MARK )); then
			CURSOR=$MARK
		fi
		zle deactivate-region
		return
	fi
	zle backward-char
}
