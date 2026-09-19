
function zpostpkgsettings {
	if [[ -n $ZSH_AUTOSUGGEST_STRATEGY ]]; then
	export ZSH_AUTOSUGGEST_STRATEGY=(history)
	typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
	export ZSH_AUTOSUGGEST_MANUAL_REBIND
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
	export ZSH_AUTOSUGGEST_IGNORE_WIDGETS
	fi
	if [[ -n $ZSH_HIGHLIGHT_STYLES ]]; then
	ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=256'
	fi
}
zpostpkgsettings
unset -f zpostpkgsettings
