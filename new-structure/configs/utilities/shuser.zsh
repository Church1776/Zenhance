function shuser {
  local unixuser=""
  if [[ $usys == "Windows" ]]; then
    unixuser=$(uname -o)
  else
    unixuser="$(uname)"
  fi
  echo "Home directories found for ${ink[$zit_user]}$USER${ink[reset]}: ${ink[$zit_nixpath]}${unixuser}${ink[reset]}${WHOME:+|}${ink[$zit_winpath]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$zit_sys]}:[$unixuser]: ${ink[$zit_nixpath]}${HOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$zit_sys]}:[Windows]: ${ink[$zit_winpath]}${WHOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
}