if [[ -e /etc/os-release ]]; then
  source /etc/os-release
  emulator="$ID"
else
  emulator="$(uname -o)"
  emulator="${(L)emulator}"
fi
echo "Emulator detected: $emulator"
subconfigs=($(find "$ZIT_LOCATION/enhancements/windows/${(L)emulator}" -maxdepth 1 -type f -name '*.zsh'))
if [[ -n $subconfigs ]]; then
  for subconfig in ${(@)subconfigs[@]}; do
    [[ -f $subconfig ]] && source $subconfig
  done
fi

unset subconfigs emulator