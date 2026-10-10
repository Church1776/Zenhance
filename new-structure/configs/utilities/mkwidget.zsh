function mkwidget {
  local ZIT_UTILITY=1
  local version="${ZIT_TOOLKIT_VERSION:-0.0.1}"
  local package_build="${ZIT_PACKAGE_BUILD:-zit-base}"
  local installed_dir="${ZIT_LOCATION:-unknown}"

  local utility_title="Make Widget"
  local util_cli_name="mkwidget"

  local errmsg=''
  local exitcode=''
  local flagcode=''

  local args=("$@")
  local valid_args=()

  if [[ -n $args ]]; then
    for arg in "${args[@]}"; do
      if [[ ! $arg == '-'* ]]; then
				valid_args+=("$arg")
			else
        case $arg in
          -h|--help)flagcode='help'; exitcode=0; break;;
          -v|--version)flagcode='version'; exitcode=0; break;;
          *) flagcode='error'; errmsg="Unknown option: $arg"; exitcode=1; break;;
        esac
      fi
		done
		if [[ -z $flagcode && -n $valid_args ]]; then
			for varg in "${valid_args[@]}"; do
				if (( ! $+functions[$varg] )); then
					errmsg="Function '$varg' not found"
					flagcode='error'
					exitcode=1
					break
				fi
				zle -N $varg
			done
		else
			flagcode='error'
			errmsg="Argument '${valid_args[*]}' is invalid"
			exitcode=1
		fi
  else
    flagcode='error'
    errmsg="No arguments provided. Must specify at least 1 argument to make a widget."
    exitcode=1
  fi
  if [[ -n $flagcode ]]; then
    case $flagcode in
      error)
        printf '%s\n' "$flagcode: $errmsg"
        ;&
      help)
        printf '%s\n' \
        "--- Zsh Enhance Toolkit $utility_title Utility ---" \
        "Usage: $util_cli_name [options]" \
        "Ex: $util_cli_name myfunc" \
        '' \
        'Options:' \
        '  -h, --help     Show this help message' \
        '  -v, --version  Show the version information' \
        ;;
      version)
        printf '%s\n' \
        "Zsh Enhance Toolkit $util_cli_name version $version ($package_build)" \
        "InstalledDir: $installed_dir"
        ;;
    esac
    return $exitcode
  fi
  if [[ -z $translated_codes ]]; then
    return
  fi
  shcolors "${translated_codes[@]}"
}