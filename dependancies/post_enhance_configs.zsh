
function zpostpkgsettings {
	if [[ -n $ZSH_AUTOSUGGEST_STRATEGY ]]; then
	export ZSH_AUTOSUGGEST_STRATEGY=(history)
		ZSH_AUTOSUGGEST_USE_ASYNC=1
		ZSH_AUTOSUGGEST_MANUAL_REBIND=1
	fi
	if [[ -n $ZSH_AUTOSUGGEST_IGNORE_WIDGETS ]]; then
		ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(
			toggle_overwrite_mode
			interactive_cd
			backward_char
			forward_char
			backward_word
			forward_word
			select_backward_char
			select_forward_char
			select_backward_word
			select_forward_word
			delete_char
			delete_word
			backward_delete_char
			backward_delete_word
			single_quote
			double_quote
			wrap_parens
			wrap_brackets
			wrap_braces
		)
	fi
	if [[ -n $ZSH_HIGHLIGHT_STYLES ]]; then
		ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'
		ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=255'
	fi
	
}
zpostpkgsettings
unset -f zpostpkgsettings
