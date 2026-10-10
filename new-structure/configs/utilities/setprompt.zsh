

function setprompt {
	local ZIT_UTILITY=1
	local version="${ZIT_TOOLKIT_VERSION:-0.0.1}"
	local package_build="${ZIT_PACKAGE_BUILD:-zit-base}"
	local installed_dir="${ZIT_LOCATION:-unknown}"

	local utility_title="Set Prompt"
	local util_cli_name="$0"
	
	local errmsg=''
	local exitcode=''
	local flagcode=''

	local args=("$@")
	local value color tmpfile
    local valid_values=(
        'name'
        'at'
        'machine'
        'system'
        'winpath'
        'unixpath'
        'winZ'
        'unixZ'
        'vcs'
        'vcs2'
        'vcs3'
        'colon'
    )

	if [[ -n "$args" ]]; then
		for arg in "${args[@]}"; do
            case $arg in
                n|name) value='name'; shift; color="$1";;
                '@'|at) value='at'; shift; color="$1";;
                m|mach|machine) value='machine'; shift; color="$1";;
                s|sys|system) value='system'; shift; color="$1";;
                w|wp|winpath) value='winpath'; shift; color="$1";;
                u|up|unixpath) value='unixpath'; shift; color="$1";;
                wZ|winZ) value='winZ'; shift; color="$1";;
                uZ|unixZ) value='unixZ'; shift; color="$1";;
                v|v1|vcs) value='vcs'; shift; color="$1";;
                v2|vcs2) value='vcs2'; shift; color="$1";;
                v3|vcs3) value='vcs3'; shift; color="$1";;
                c|colon) value='colon'; shift; color="$1";;
            esac
			if [[ "$value" == '-'* ]]; then
                case $value in
			        -h|--help)flagcode='help'; exitcode=0; break;;
        			-v|--version)flagcode='version'; exitcode=0; break;;
    				*) flagcode='error'; errmsg="Unknown option: $value"; exitcode=1; break;;
				esac
			elif [[ ! " ${valid_values[@]} " =~ " ${value} " ]]; then
				flagcode="error"
				errmsg="Invalid prompt value: '$value'."
				exitcode=1
			fi
		done
	else
		flagcode="error"
		errmsg="No prompt value selected."
		exitcode=1
	fi
	if [[ -z "$flagcode" ]]; then
        export gps[$value]="$color"
        zit_name="${gps[$value]}"
        tmpfile=$(<"$ZIT_LOCATION/new-structure/cache/prompt.zsh")
        echo -e "Original: \n$tmpfile"
        sed -i.bak "s/gps\[$value\]='.*'/gps\[$value\]='$color'/" "$ZIT_LOCATION/new-structure/cache/prompt.zsh"
        rm -f "$ZIT_LOCATION/new-structure/cache/prompt.zsh.bak"
        tmpfile=$(<"$ZIT_LOCATION/new-structure/cache/prompt.zsh")
        echo -e "Updated: \n$tmpfile"
        return
        print -r -- "${tmpfile//gps[$value]=\'*\'/gps[$value]=${(q)color}}" > "$ZIT_LOCATION/new-structure/cache/prompt.zsh"
	else
		case "$flagcode" in
			error)
				printf '%s\n' "$flagcode: $errmsg"
				;&
			help)
				printf '%s\n' \
				"--- $utility_title Utility ---" \
				"Usage: $util_cli_name [style]" \
				"Ex: $util_cli_name system 37" \
				'' \
				'Options:' \
				'  -h, --help     Show this help message' \
				'  -v, --version  Show the version information' \
                '' \
                'Prompt values:' \
                '  name      Set username color' \
                '  at        Set @ symbol color' \
                '  machine   Set machine name color' \
                '  system    Set system name color' \
                '  winpath   Set Win32 path color' \
                '  unixpath  Set Unix path color' \
                '  winZ      Set Win32 Z color' \
                '  unixZ     Set Unix Z color' \
                '  vcs       Set VCS status color' \
                '  vcs2      Set VCS secondary color' \
                '  vcs3      Set VCS tertiary color' \
                '  colon     Set colon color' \
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