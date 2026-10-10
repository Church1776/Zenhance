function shuser {
  local ZIT_UTILITY=1
  local version="${ZIT_TOOLKIT_VERSION:-0.0.1}"
  local package_build="${ZIT_PACKAGE_BUILD:-zit-base}"
  local installed_dir="${ZIT_LOCATION:-unknown}"

  local posix_env=""
  if [[ -n $ZIT_TRUENAME ]]; then
    posix_env="$ZIT_TRUENAME"
  elif [[ -n $NAME ]]; then
    posix_env="$NAME"
  else
    posix_env="Unknown"
  fi
  echo "Home directories found for ${ink[$zit_user]}$USER${ink[reset]}: ${ink[$zit_unxpath]}${posix_env}${ink[reset]}${WHOME:+|}${ink[$zit_winpath]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$zit_sys]}:[$posix_env]: ${ink[$zit_unxpath]}${HOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$zit_sys]}:[Windows]: ${ink[$zit_winpath]}${WHOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
}