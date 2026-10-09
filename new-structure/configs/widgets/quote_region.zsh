function quote_region() {
  local ZIT_WIDGET=1
  local quoter="$1"
  if (( REGION_ACTIVE )); then
    wrap_region "$quoter" "$quoter"
    return
  fi
  local text=$LBUFFER
  local char next
  local state=unquoted
  local -i i

  for (( i = 1; i <= ${#text}; ++i )); do
    char=${text[i]}
    case $state:$char in
      unquoted:\\)(( ++i ));;
      unquoted:\')state=single_quoted;;
      unquoted:\")state=double_quoted;;
      single_quoted:\')state=unquoted;;
      double_quoted:\")state=unquoted;;
      double_quoted:\\)
        next=${text[i + 1]}
        [[ $next == [\$\\\"\`$'\n'] ]] && (( ++i ))
        ;;
    esac
  done
  case $state in
    unquoted) open_region "$quoter" "$quoter";;
    single_quoted) close_region "$quoter" "$quoter";;
    double_quoted) close_region "$quoter" "$quoter";;
  esac
}