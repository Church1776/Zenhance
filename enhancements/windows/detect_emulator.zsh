if [[ -e /etc/os-release ]]; then
  source /etc/os-release
  emulator="$ID"
else
  emulator="$(uname -o)"
  emulator="${(L)emulator}"
fi

subconfigs=($(find "$ZENHANCE/enhancements/windows/${(L)usys}" -maxdepth 1 -type f -name '*.zsh'))
if [[ -n $subconfigs ]]; then
  for subconfig in ${(@)subconfigs[@]}; do
    [[ -f $subconfig ]] && source $subconfig
  done
fi

unset subconfigs emulator