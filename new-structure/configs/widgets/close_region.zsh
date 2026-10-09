function close_region() {
  local ZIT_WIDGET=1
  local opener="$1"
  local closer="$2"
  if (( REGION_ACTIVE )); then
    wrap_region "$opener" "$closer"
    return
  fi
  if [[ $RBUFFER[1] != $closer ]]; then
    RBUFFER=${closer}${RBUFFER}
  fi
  (( CURSOR++ ))
}