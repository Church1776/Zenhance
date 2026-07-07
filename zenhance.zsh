#!/bin/zsh

# Z Shell easy color modifiers for changing the terminal user prompt.
usys=$(uname ${MSYSTEM:+'-o'}) # Check for MSYS2 environment to use 'Msys' for certain display functions.
name=${name:-'turquoise'}
AT=${AT:-'brightgreen'}
machine=${machine:-'mint'}
system_env=${system_env:-'periwinkle'}
unix_path=${unix_path:-'gold'}
unix_Z=${unix_Z:-'brightergold'}
win32_path=${win32_path:-'cerulean'}
win32_Z=${win32_Z:-'brighterskyblue'}
vcs_branch=${vcs_branch:-'gray'}
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
  echo "Home directories found for ${ink[$name]}$USER${ink[reset]}: ${ink[$unix_path]}$usys${ink[reset]}${WHOME:+|}${ink[$win32_path]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$system_env]}:[$usys]: ${ink[$unix_path]}${HOME%$USER}${ink[$name]}$USER${ink[reset]}"
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
git_repo_root=""
git_branch_info=""
git_hash_length=0
if git rev-parse --show-toplevel &>/dev/null; then
  git_repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"

fi

# Pre-Command Function for the prompt.
function precmd {
  if [[ $usys == 'Msys' ]]; then
    case $MSYSTEM in
      CLANG64)USYSTEM='Clang64';;
      CLANGARM64)USYSTEM='ClangArm64';;
      MINGW64)USYSTEM='MinGW64';;
      MINGW32)USYSTEM='MinGW32';;
      UCRT64)USYSTEM='UCRT64';;
      MSYS)USYSTEM='Msys';;
    esac
  else
    USYSTEM="${NAME:-$usys}"
  fi
  if [[ -z $git_repo_root || $PWD != $git_repo_root* ]]; then
    git_repo_root=""
    if [[ -n $git_branch_info ]]; then
      git_branch_info=""
    fi
    if [[ $git_hash_length -ne 0 ]]; then
      git_hash_length=0
    fi
    local tempPWD=$PWD
    while [[ -n $tempPWD && $tempPWD != "/" ]]; do
      if [[ -d "$tempPWD/.git" ]]; then
        git_repo_root="$tempPWD"
        break
      fi
      tempPWD="${tempPWD:h}"
    done
  fi
  if [[ -n $git_repo_root ]]; then
    read -r git_branch_info < "$git_repo_root/.git/HEAD"
    if [[ $git_branch_info == ref:\ refs/heads/* ]]; then
      git_branch_info="${git_branch_info#ref: refs/heads/}"
    else
      if [[ -z $git_hash_length ]]; then
        local git_short_hash_id="$(git rev-parse --short HEAD 2>/dev/null)"
        git_hash_length=${#git_short_hash_id}
      fi
        read -k $git_hash_length -r git_branch_info "$git_repo_root/.git/HEAD"
        git_branch_info="HEAD@${git_branch_info:0:$git_hash_length}"
    fi
    if [[ -n $git_branch_info ]]; then
      git_branch_info="%{${ink[$vcs_branch]}%}($git_branch_info)%{${ink[reset]}%} "
    fi
  fi

  if [[ $PWD == "/"[a-z] && -n $MSYSTEM && $PWD != ${MROOT}* || $PWD == "/"[a-z]/* && -n $MSYSTEM && $PWD != ${MROOT}* || $PWD == "/mnt/"[a-z] && -n $WSL_DISTRO_NAME || $PWD == "/mnt/"[a-z]/* && -n $WSL_DISTRO_NAME ]]; then
    PROMPT="%{${ink[$name]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$win32_path]}%}${PWD/$WHOME/~}%{${ink[$win32_Z]}%}%#${ink[reset]} ${git_branch_info}"
  else
    if [[ $PWD == $MROOT && -n $MSYSTEM ]]; then
      cd - &>/dev/null
      cd / &>/dev/null
    fi
    PROMPT="%{${ink[$name]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$unix_path]}%}%~%{${ink[$unix_Z]}%}%#${ink[reset]} ${git_branch_info}"
  fi
  return
}
