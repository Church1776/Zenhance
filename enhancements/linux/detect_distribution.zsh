if [[ -e /etc/os-release ]]; then
  distro=$(cat /etc/os-release | sed '/^ID=.*/!d' | sed 's/^ID=\(.*\)/\1/g' )
fi

if [[ ! -d "$ZIT_LOCATION/enhancements/linux/${(L)distro}" ]]; then
  if [[ $+commands[apt] || $+commands[dpkg] ]]; then
    distro="debian"
  elif [[ $+commands[apk] ]]; then
    distro="alpine"
  elif [[ $+commands[yum] || $+commands[dnf] ]]; then
    distro="redhat"
  elif [[ $+commands[pacman] || $+commands[paru] || $+commands[yay] ]]; then
    distro="arch"
  elif [[ $+commands[zypper] ]]; then
    distro="suse"
  elif [[ $+commands[xbps-install] ]]; then
    distro="void"
  fi
fi

function load_subconfigs {
  local configs=()
  subconfigs=($(find "$ZIT_LOCATION/enhancements/linux/${(L)distro}" -maxdepth 1 -type f -name '*.zsh'))
  if [[ -n $subconfigs ]]; then
    for subconfig in ${(@)subconfigs[@]}; do
      [[ -f $subconfig ]] && source $subconfig
    done
  fi
}
load_subconfigs
if [[ $READY_FOR_PRECMD ]]; then
  source "$ZENHANCE/enhancements/linux/${(L)distro}/precmd.zsh"
fi
