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
				
			done
        if [[ ! $lcode =~ '^[0-9]+$' || $lcode -gt 255 ]]; then
          flagcode='error'
          errmsg="Invalid range: $code"
          exitcode=1
          break
        fi
        if [[ ! $rcode =~ '^[0-9]+$' || $rcode -gt 255 ]]; then
          flagcode='error'
          errmsg="Invalid range: $code"
          exitcode=1
          break
        fi
        [[ $lcode == 'reset' ]] && lcode=256
        [[ $lcode == 'begin' ]] && lcode=0
        [[ $lcode == 'end' ]] && lcode=256
        [[ $rcode == 'reset' ]] && rcode=256
        [[ $rcode == 'begin' ]] && rcode=0
        [[ $rcode == 'end' ]] && rcode=256
        if (( lcode > rcode )); then
          arg="$rcode..$lcode"
        else
          arg="$lcode..$rcode"
        fi
      else
        if [[ ! $code =~ '^[0-9]+$' ]] && [[ $code != 'reset' && $code != 'begin' && $code != 'end' ]]; then
          flagcode='error'
          errmsg="Argument '$code' must be a 256 ANSI code: 0..256|reset"
          exitcode=1
          break
        fi
      fi
      case $code in
        'all')
          code="0..256"
          ;&
        *'..'*)
          for (( i = ${code%%..*}; i <= ${code##*..}; ++i )); do
            [[ "$i" -eq '256' ]] && translated_codes+=("reset") && continue
            translated_codes+=("$i")
          done
          continue
        ;;
      esac
      [[ "$code" == '256' ]] && code=reset
      translated_codes+=("$code")
    done
    if [[ ${#translated_codes[@]} -lt 2 && -z $flagcode ]]; then
      flagcode='error'
      errmsg="Must specify at least 2 color codes or a valid range to compare."
      exitcode=1
    fi
  else
    flagcode='error'
    errmsg="No color codes specified. Must specify at least 2 color codes or a range to compare."
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
        "Usage: $util_cli_name [optional] [color] [code..range]" \
        "Ex: $util_cli_name 0 1 2 3..9" \
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