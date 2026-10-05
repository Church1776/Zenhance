# Show Color of the given 256 ANSI code OR show all available colors to the terminal.
#
# % shcolors [optional] [codes]
#
# The following Show Colors 'shcolors' utility is the primary tool to display the colors codes within the Ink Dictionary.
#
# Utility will output the color of any given ansi 256 code input, or else print all available colors.
# The formatting will default to a table of 8 columns, unless you decide to change it by assigning a value to SHCOLORSCOLUMNS.
# The spacing is determined by the width of the code passed to the utility plus SHCOLORSPADDING or a default padding of 2.

function shcolors {
	local ZIT_UTILITY=1
  local version="${ZIT_TOOLKIT_VERSION:-0.0.1}"
  local package_build="${ZIT_PACKAGE_BUILD:-zit-base}"
  local installed_dir="${ZIT_LOCATION:-unknown}"

  local utility_title="Show Colors"
  local util_cli_name="shcolors"

  local errmsg=''
  local exitcode=''
  local flagcode=''

  local args=("$@")

  local codes=("${args[@]}")
  local columns="${SHCOLORSCOLUMNS:-8}"
  local padsetting="${SHCOLORSPADDING:-2}"
  local printed=0
  local needfeed=0

  local pads reset padding linefeed

  if [[ -z $ink ]]; then
    echo "info: No colors found."
    return 1
  fi
  if (( padsetting > 0 )); then
      for (( i=0; i < $padsetting; ++i )); do
        pads+=" "
      done
    fi
  if [[ -z $codes ]]; then
    echo "Colors loaded:"
    for (( i = 0; i < 256; i++ )); do
      if (( i < 10 )); then
        padding="$pads  "
      elif (( i < 100 )); then
        padding="$pads "
      else
        padding="$pads"
      fi
      color="$i"
      (( printed < $columns )) || { linefeed='\n'; }
      printf "${linefeed}"'%s' "${ink[$color]}ColorCode:$color${ink[reset]}${padding}"
      [[ -n $linefeed ]] && { linefeed=''; printed=0; }
      (( ++printed ))
    done
    (( printed < $columns )) || { linefeed='\n'; printed=0; }
    printf "$linefeed"'%b\n' "${ink[reset]}ColorCode:reset${ink[reset]}"
    return
  fi
  for code in "${codes[@]}"; do
    if [[ $code == '-'* ]]; then
      case $code in
        -h|--help)flagcode='help'; exitcode=0; break;;
        -v|--version)flagcode='version'; exitcode=0; break;;
        *) flagcode='error'; errmsg="Unknown option: $code"; exitcode=1; break;;
      esac
    fi
    if [[ ! $code =~ '^[0-9]+$' ]] && [[ $code != 'reset' ]] || (( code > 255 )); then
      flagcode='error'
      errmsg="Argument '$code' must be a 256 ANSI code."
      exitcode=1
      break
    fi
    if [[ $code -lt 10 ]]; then
      padding="$pads  "
    elif [[ $code -lt 100 ]]; then
      padding="$pads "
    else
      padding="$pads"
    fi
    (( printed >= $columns )) && { linefeed='\n'; }
    printf "$linefeed"'%b' "${ink[$code]}ColorCode:$code${ink[reset]}${padding}"
    [[ -n $linefeed ]] && { linefeed=''; printed=0; }
    (( needfeed == 0 )) && { needfeed=1; }
    (( ++printed ))
  done
  (( needfeed == 1 )) && { printf '\n'; }
  if [[ -n $flagcode ]]; then
    case $flagcode in
      error)
        printf '%s\n' "$flagcode: $errmsg"
        ;&
      help)
        printf '%s\n' \
        "--- Zsh Enhance Toolkit $utility_title Utility ---" \
        "Usage: $util_cli_name [optional] [color] [codes]" \
        "Ex: $util_cli_name 0 1 2 3" \
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
}