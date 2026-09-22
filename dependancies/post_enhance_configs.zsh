
function zpostpkgsettings {
	if [[ -n $ZSH_AUTOSUGGEST_STRATEGY ]]; then
	export ZSH_AUTOSUGGEST_STRATEGY=(history)
		ZSH_AUTOSUGGEST_USE_ASYNC=1
		ZSH_AUTOSUGGEST_MANUAL_REBIND=1
	fi
	if [[ -n $ZSH_AUTOSUGGEST_IGNORE_WIDGETS ]]; then
		ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(
			backward_char
			forward_char
			backward_word
			forward_word
			delete_char
			delete_word
		)
	fi
	if [[ -n $ZSH_HIGHLIGHT_STYLES ]]; then
		ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'
		ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=255'
	fi
	
}
zpostpkgsettings
unset -f zpostpkgsettings
