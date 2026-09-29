function cmpcolors {
  local codes=("${(@s.,.)@}")
  local translated_codes=()
  local errmsg=''
  local argcode=''
  local exitcode=''
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
    argcode='[error]'
    errmsg="Must specify at least 2 color codes or a range to compare."
    exitcode=1
  fi
  if [[ -n $argcode ]]; then
    case $argcode in
      '[error]')
        printf '%s\n' "$argcode $errmsg"
        ;&
      'help')
        printf '%s\n' \
        'Usage: cmpcolors [optional] [color] [code..range]' \
        'Ex: cmpcolors 1 2 3 4 5' \
        'Ex: cmpcolors 24..30'
        ;;
    esac
    return $exitcode
  fi
  if [[ -z $translated_codes ]]; then
    return
  fi
  shcolors "${translated_codes[@]}"
}