# Set the Cursor style for the terminal cursor.
#
# % setcursor [mandatory 1] [style]
#
# The following Set Cursor 'setcursor' function allows easier configuration of the terminal cursor style.
#
# A cursor style must be passed as an argument to the function.
# The function will output the escape sequence for the specified cursor style.
# This utility has no formatting features.
#

function setcursor {
	local ZE_PROCESS=1
	local version="${ZE_TOOLKIT_VERSION:-0.0.1}"
	local package_build="${ZE_PACKAGE_BUILD:-builtin-toolkit}"
	local utility_title="Set Cursor"
	local util_cli_name="setcursor"
	
	local errmsg=''
	local exitcode=''
	local flagcode=''

	local valid_styles=(${(k)pen})
	local installed_dir="${ZE_LOCATION:-unknown}"
	local args=("$@")

	local styles=("${args[@]}")

	if [[ -n "$styles" ]]; then
		for style in "${styles[@]}"; do
			if [[ "$style" == '-'* ]]; then
				case $style in
          -h|--help)flagcode='help'; exitcode=0; break;;
          -v|--version)flagcode='version'; exitcode=0; break;;
          *) flagcode='error'; errmsg="Unknown option: $code"; exitcode=1; break;;
				esac
			elif [[ ! " ${valid_styles[@]} " =~ " ${style} " ]]; then
				flagcode="error"
				errmsg="Invalid cursor style: '$style'."
				exitcode=1
			elif [[ "${#valid_styles}" -gt 1 ]]; then
				flagcode="error"
				errmsg="Multiple cursor styles provided. Only one style can be set at a time."
				exitcode=1
			fi
		done
	else
		flagcode="error"
		errmsg="No cursor style provided."
		exitcode=1
	fi
	if [[ -z "$flagcode" ]]; then
		printf "%s" "${pen[$style]}"
	else
		case "$flagcode" in
			error)
				printf '%s\n' "$flagcode: $errmsg"
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
				"InstalledDir: $installed_dir"
				;;
		esac
		return "$exitcode"
	fi
}