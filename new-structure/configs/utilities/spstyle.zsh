# Set the Pen Style for the terminal cursor.
#
# % spstyle [mandatory style]
#
# The following Set Pen Style 'spstyle' function allows easier configuration of the terminal cursor style.
#
# A cursor style must be passed as an argument to the function.
# The function will output the escape sequence for the specified cursor style.
# This utility has no formatting features.
#

function spstyle {
	local version="${ZENHANCE_TOOLKIT_VERSION:-0.0.1}"
	local package_build="${ZENHANCE_PACKAGE_BUILD:-builtin-toolkit}"
	local utility_title="Set Pen Style"
	local util_cli_name="spstyle"
	
	local argcode=''
	local errmsg=''
	local exitcode=''

	local style=("$@")
	local valid_styles=(${(k)pen})

	if [[ -z "$style" ]]; then
		argcode="error"
		errmsg="No cursor style provided."
		exitcode=1
	elif [[ ! " ${valid_styles[@]} " =~ " ${style} " ]]; then
		argcode="error"
		errmsg="Invalid cursor style: '$style'."
		exitcode=1
	elif [[ "${#valid_styles}" -gt 1 ]]; then
		argcode="error"
		errmsg="Multiple cursor styles provided. Only one style can be set at a time."
		exitcode=1
	fi
	if [[ -z "$argcode" ]]; then
		printf "%s" "${pen[$style]}"
	else
		case "$argcode" in
			error)
				printf '%s\n' "$argcode: $errmsg"
				;&
			help)
				printf '%s\n' \
				"--- $utility_title Utility ---" \
				"Usage: $util_cli_name [style]" \
				"Ex: $util_cli_name blinkline" \
				'' \
				'Options:' \
				'  -h, --help     Show this help message' \
				'  -v, --version  Show the version information' \
				'' \
				'Valid Styles:' \
				"  ${valid_styles[*]}"
				;;
			version)
				printf '%s\n' \
				"Zenhance $util_cli_name version $version ($package_build)" \
				"InstalledDir: $ZENHANCE"
				;;
		esac
		return "$exitcode"
	fi
}