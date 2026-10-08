if [[ -e /etc/os-release ]]; then
  emulator=$(cat /etc/os-release | sed -n 's/^ID=\(.*\)$/\1/p')
  emulator="${(L)emulator}"
else
  emulator="$(uname -o)"
  emulator="${(L)emulator}"
fi
subconfigs=($(find "$ZIT_LOCATION/enhancements/windows/${(L)emulator}" -maxdepth 1 -type f -name '*.zsh'))
if [[ -n $subconfigs ]]; then
  for subconfig in ${(@)subconfigs[@]}; do
    [[ -f $subconfig ]] && source $subconfig
  done
fi

unset subconfigs emulator