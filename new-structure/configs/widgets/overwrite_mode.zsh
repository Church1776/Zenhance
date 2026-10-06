overwrite_mode() { zle overwrite-mode;
	[[ $ZLE_STATE == *"overwrite"* ]] && { 
		echo -ne '\e[1 q\e[?12h'
		return
	}
	echo -ne '\e[3 q\e[?12h'
}