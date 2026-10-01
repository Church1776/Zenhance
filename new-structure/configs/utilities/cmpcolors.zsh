# Compare 2 or more Colors of the given 256 ANSI code '0-255' arguments passed in either a sequential or range format.
#
# % cmpcolors [mandatory 2+] [color codes|code..range]
#
# The following Compare Colors 'cmpcolors' utility wraps Show Colors 'shcolors' to allow for checking ranges of colors.
#
# Utility will output the color of any given ansi 256 code or code range. As well as the following words: begin, end, all, & reset.
# A range is specified using double dot notation '..'. A range will always print low..high output regardless if input is low..high|high..low.
# Ex: begin..15, 6..7, 15..end, 0..reset
# This utility has no formatting features. Formatting is handled by the 'shcolors' utility.
#

function cmpcolors {
  local ZIT_UTILITY=1
  local version="${ZIT_TOOLKIT_VERSION:-0.0.1}"
  local package_build="${ZIT_PACKAGE_BUILD:-ze-toolkit}"
  local installed_dir="${ZIT_LOCATION:-unknown}"

  local utility_title="Compare Colors"
  local util_cli_name="cmpcolors"

	local errmsg=''
	local exitcode=''
	local flagcode=''

	local args=("$@")

  local codes=("${args[@]}")
  local lcode rcode
  local translated_codes=()

  if [[ -n $codes ]]; then
    for code in "${codes[@]}"; do
      if [[ $code == '-'* ]]; then
        case $code in
          -h|--help)flagcode='help'; exitcode=0; break;;
          -v|--version)flagcode='version'; exitcode=0; break;;
          *) flagcode='error'; errmsg="Unknown option: $code"; exitcode=1; break;;
        esac
      fi
      if [[ $code == *'..'* ]]; then
        lcode="${code%%..*}"
        rcode="${code##*..}"
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
          code="$rcode..$lcode"
        else
          code="$lcode..$rcode"
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