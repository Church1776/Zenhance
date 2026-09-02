#!/usr/bin/zsh

# Z Shell easy color modifiers for changing the terminal user prompt.
usys=$(uname ${MSYSTEM:+'-o'}) # Check for MSYS2 environment to use 'Msys' for certain display functions.
username=${username:-'orange'}
AT=${AT:-'amber'}
machine=${machine:-'vanilla'}
system_env=${system_env:-'slateblue'}
unix_path=${unix_path:-'turquoise'}
unix_Z=${unix_Z:-'mint'}
win32_path=${win32_path:-'cerulean'}
win32_Z=${win32_Z:-'brighterskyblue'}
vcs_clr=${vcs_clr:-'gray'}
vcs_cl2=${vcs_cl2:-'lightgray'}
vcs_cl3=${vcs_cl3:-'reset'}
colon=${colon:-'gray'}

# Cursor styles (uncomment one)
#echo -ne '\e[0 q'         # Default (terminal-dependent)
#echo -ne '\e[1 q'  # Blinking block
#echo -ne '\e[2 q'         # Steady block
echo -ne '\e[3 q'  # Blinking underline
#echo -ne '\e[4 q'         # Steady underline
#echo -ne '\e[5 q'  # Blinking bar (I-beam)
#echo -ne '\e[6 q'         # Steady bar (recommended for modern terminals)

# Configure Windows home directory. I'm Assuming the Windows environment is available to the User.
[[ $usys == 'Msys' ]] && WHOME=$(cygpath -u ${WINDIR%%\\*})/Users/$USER
WHOME=${WHOME:-"$(find /mnt -maxdepth 3 -type d -name "$USER" 2>/dev/null)"}

# Initialize shell configurations relative to script's location.
zenhance="${(%):-%N}" &>/dev/null
configs=($(find ${zenhance:A:h}/enhancements/${(L)usys} -type f -name '*.zsh'))
configs+=($(find ${zenhance:A:h}/enhancements -maxdepth 1 -type f -name '*.zsh' ))
if [[ -n $configs ]]; then
  for config in ${(@)configs[@]}; do
    [[ -f $config ]] && source $config
  done
fi

# Display Shell User paths.
function shuser {
  echo "Home directories found for ${ink[$username]}$USER${ink[reset]}: ${ink[$unix_path]}$usys${ink[reset]}${WHOME:+|}${ink[$win32_path]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$system_env]}:[$usys]: ${ink[$unix_path]}${HOME%$USER}${ink[$username]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$system_env]}:[Windows]: ${ink[$win32_path]}${WHOME%$USER}${ink[$name]}$USER${ink[reset]}"
}

# Grab the msys2 root path for the precmd function.
if [[ -n $MSYSTEM ]]; then
  MROOT="$(cygpath -m /)"
  MROOT="/${(L)MROOT//:/}"
  MROOT="${MROOT%/}"
fi

# Check for Linux system and grab the distro name for the precmd function.
if [[ $usys == 'Linux' ]]; then
  source /etc/os-release
  NAME="$NAME"
fi

# Check if in a git repository and grab the root directory for the precmd function.
vcs_root=""
vcs_data=""
vcs_branch=""
vcs_hash_length=""
cached_usystem=""
cached_directory=""
if git rev-parse --show-toplevel &>/dev/null; then
  vcs_root="$(git rev-parse --show-toplevel 2>/dev/null)"

fi

# Pre-Command Function for the prompt.
function precmd {
  if [[ "$USYSTEM" != "$cached_usystem" || -z $USYSTEM ]]; then
    if [[ $usys == 'Msys' ]]; then
      case $MSYSTEM in
        CLANG64)NAME='Clang64';;
        CLANGARM64)NAME='ClangArm64';;
        MINGW64)NAME='MinGW64';;
        MINGW32)NAME='MinGW32';;
        UCRT64)NAME='UCRT64';;
        MSYS)NAME='Msys';;
      esac
      USYSTEM="${NAME:-$usys}"
      cached_usystem="$USYSTEM"
    fi
  fi
  if [[ $PWD != $cached_directory ]] && [[ $PWD == $vcs_root/* && -e "$PWD/.git" || $PWD != $vcs_root/* && $PWD != $vcs_root ]]; then
    vcs_root=""
    vcs_data=""
    vcs_branch=""
    vcs_hash_length=""
    local tempPWD=$PWD
    while [[ -n $tempPWD && $tempPWD != "/" ]]; do
      if [[ -e "$tempPWD/.git" ]]; then
        vcs_root="$tempPWD"
        break
      fi
      tempPWD="${tempPWD:h}"
    done
  fi
  if [[ -n $vcs_root ]]; then
    if [[ ! -d "$vcs_root/.git" && -z $vcs_data ]]; then
      read -r vcs_data < "$vcs_root/.git"
      vcs_data="${vcs_data#gitdir: }"
    fi
    read -r vcs_branch < "${vcs_data:-$vcs_root/.git}/HEAD"
    if [[ $vcs_branch == ref:\ refs/heads/* ]]; then
      vcs_branch="${vcs_branch#ref: refs/heads/}"
    else
      if [[ -z $vcs_hash_length ]]; then
        vcs_hash_length="$(git rev-parse --short HEAD 2>/dev/null)"
        vcs_hash_length=${#vcs_hash_length}
      fi
      vcs_branch="HEAD%{${ink[$vcs_cl2]}%}@%{${ink[$vcs_cl3]}%}${vcs_branch:0:$vcs_hash_length}%{${ink[$vcs_clr]}%}"
    fi
    vcs_branch="%{${ink[$vcs_clr]}%}($vcs_branch)%{${ink[reset]}%} "
  fi
  if [[ $PWD == /[a-zA-Z] && -n $MSYSTEM && $PWD != $MROOT || $PWD == /[a-zA-Z]/* && -n $MSYSTEM && $PWD != $MROOT/* || $PWD == /mnt/[a-zA-Z] && -n $WSL_DISTRO_NAME || $PWD == /mnt/[a-zA-Z]/* && -n $WSL_DISTRO_NAME ]]; then
    cached_directory="$PWD"
    PROMPT="%{${ink[$username]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$win32_path]}%}${PWD/$WHOME/~}%{${ink[$win32_Z]}%}%#%{${ink[reset]}%} ${vcs_branch}"
  else
    if [[ $PWD == $MROOT && -n $MSYSTEM ]]; then
      cd - &>/dev/null
      cd / &>/dev/null
    fi
    cached_directory="$PWD"
    PROMPT="%{${ink[$username]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$unix_path]}%}%~%{${ink[$unix_Z]}%}%#%{${ink[reset]}%} ${vcs_branch}"
  fi
  return
}
