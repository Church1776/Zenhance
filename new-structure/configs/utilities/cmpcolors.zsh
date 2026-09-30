function cmpcolors {
  local version="${ZENHANCE_TOOLKIT_VERSION:-0.0.1}"
  local package_build="${ZENHANCE_PACKAGE_BUILD:-'builtin-toolkit'}"
  local utility_title="Compare Colors"
  local util_cli_name="cmpcolors"

	local argcode=''
	local errmsg=''
	local exitcode=''

  local codes=("${(@s.,.)@}")
  local translated_codes=()

  if [[ -n $codes ]]; then
    for code in "${codes[@]}"; do
      if [[ $code == '-'* ]]; then
        case $code in
          -h|--help)argcode='help'; exitcode=0; break;;
          *) argcode='[error]'; errmsg="Unknown option: $code"; exitcode=1; break;;
        esac
      fi
      if [[ ! $code =~ '^[0-9]+$' ]] && [[ $code != 'reset' ]] && [[ $code != *'..'* ]] || (( code > 255 )); then
        argcode='[error]'
        errmsg="Argument '$code' must be a 256 ANSI code."
        exitcode=1
        break
      fi
      case $code in
        *'..'*)
          [[ "${code##*..}" == 'reset' ]] && code="${code%%..*}..256"
          for (( i = ${code%%..*}; i <= ${code##*..}; i++ )); do
            [[ "$i" -eq '256' ]] && translated_codes+=("reset") && continue
            translated_codes+=("$i")
          done
          continue
        ;;
      esac
      translated_codes+=("$code")
    done
  fi
  if [[ ${#translated_codes[@]} -lt 2 || -z $codes ]]; then
    argcode='error'
    errmsg="Must specify at least 2 color codes or a range to compare."
    exitcode=1
  fi
  if [[ -n $argcode ]]; then
    case $argcode in
      error)
        printf '%s\n' "$argcode: $errmsg"
        ;&
      help)
        printf '%s\n' \
        "--- $utility_title Utility ---" \
        "Usage: $util_cli_name [optional] [color] [code..range]" \
        "Ex: $util_cli_name 0 1 2 3..9" \
        '' \
        'Options:' \
        '  -h, --help     Show this help message' \
        '  -v, --version  Show the version information' \
        ;;
      version)
        printf '%s\n' \
        "Zenhance $util_cli_name version $version ($package_build)" \
        "InstalledDir: $ZENHANCE"
        ;;
    esac
    return $exitcode
  fi
  if [[ -z $translated_codes ]]; then
    return
  fi
  shcolors "${translated_codes[@]}"
}