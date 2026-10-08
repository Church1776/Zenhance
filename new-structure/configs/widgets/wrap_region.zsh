function wrap_region() {
  if [[ -z $ZIT_WIDGET && -z $ZIT_CUSTOM_WIDGET ]]; then
    return
  fi
  if (( ! REGION_ACTIVE )); then
    return
  fi
  local opchar="$1"
  local clchar="$2"
  (( MARK > CURSOR )) && { local -i ORIG=CURSOR; CURSOR=$MARK; MARK=$ORIG; }
  local text=${BUFFER[MARK+1,CURSOR]}
  local wrapped=${opchar}${text}${clchar}
  BUFFER="${BUFFER[1,MARK]}${wrapped}${BUFFER[CURSOR+1,-1]}"
  (( CURSOR += 2 ))
  [[ -n $ORIG ]] && { MARK=$CURSOR; CURSOR=$ORIG; }
  zle reset-prompt
}