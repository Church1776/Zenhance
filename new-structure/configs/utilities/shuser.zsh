function shuser {
  local posix_env=""
  if [[ -z $ZIT_TRUENAME ]]; then
    posix_env="Unknown"
  fi
  echo "Home directories found for ${ink[$zit_user]}$USER${ink[reset]}: ${ink[$zit_unxpath]}${posix_env}${ink[reset]}${WHOME:+|}${ink[$zit_winpath]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$zit_sys]}:[$posix_env]: ${ink[$zit_unxpath]}${HOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$zit_sys]}:[Windows]: ${ink[$zit_winpath]}${WHOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
}