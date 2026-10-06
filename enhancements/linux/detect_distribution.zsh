if [[ -e /etc/os-release ]]; then
  distro=$(cat /etc/os-release | sed '/^ID=.*/!d' | sed 's/^ID=\(.*\)/\1/g' )
fi
if [[ $READY_FOR_PRECMD ]]; then
  source "$ZENHANCE/enhancements/linux/$ID_LIKE/precmd.zsh"
fi
