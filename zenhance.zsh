#!/bin/zsh
0="${(%):-%N}" &>/dev/null

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

# Define the selection widgets
# Initialize shell configurations.

configs=($(find ${0:A:h}/enhancements -maxdepth 1 -type f -name '*.zsh' ))
configs+=($(find ${0:A:h}/enhancements/${(L)usys} -type f -name '*.zsh'))
if [[ -n $configs ]]; then
  for config in ${(@o)configs[@]}; do
    [[ -f $config ]] && source $config
  done
fi

# Configure Windows home directory. I'm Assuming the Windows environment is available to the User.
[[ $usys == 'Msys' ]] && WHOME=$(cygpath -u $USERPROFILE)
WHOME=${WHOME:-"$(find /mnt -maxdepth 3 -type d -name "$USER" 2>/dev/null)"}
# Display Shell User paths.
function shuser {
  echo "Home directories found for ${ink[$name]}$USER${ink[reset]}: ${ink[$unix_path]}$usys${ink[reset]}${WHOME:+|}${ink[$win32_path]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$system_env]}:[$usys]: ${ink[$unix_path]}${HOME%$USER}${ink[$name]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$system_env]}:[Windows]: ${ink[$win32_path]}${WHOME%$USER}${ink[$name]}$USER${ink[reset]}"
}

# Grab the msys2 root path for the precmd function.
if [[ -n $MSYSTEM ]]; then
  cd / &>/dev/null
  MROOT="$(cygpath -m "$PWD")"
  MROOT="/${(L)MROOT//:/}"
  MROOT="${MROOT%/}"
  cd - &>/dev/null
fi

# Check for Linux system and grab the distro name for the precmd function.
if [[ $usys == 'Linux' ]]; then
  source /etc/os-release
  NAME="$NAME"
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
  if git_branch_info="$(git branch --show-current 2>/dev/null)" && [[ -z $git_branch_info ]]; then
    git_branch_info="HEAD@$(git rev-parse --short HEAD 2>/dev/null)"
  fi
  if [[ -n $git_branch_info ]]; then
    git_branch_info="%{${ink[$vcs_branch]}%}($git_branch_info)%{${ink[reset]}%}%f "
  fi
  if [[ $PWD == "/"[a-z] && -n $MSYSTEM && $PWD != ${MROOT}* || $PWD == "/"[a-z]/* && -n $MSYSTEM && $PWD != ${MROOT}* || $PWD == "/mnt/"[a-z] && -n $WSL_DISTRO_NAME || $PWD == "/mnt/"[a-z]/* && -n $WSL_DISTRO_NAME ]]; then
    PROMPT="%{${ink[$name]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$win32_path]}%}${PWD/$WHOME/~}%{${ink[$win32_Z]}%}%#${ink[reset]} %{${git_branch_info}%}"
  else
    if [[ $PWD == $MROOT && -n $MSYSTEM ]]; then
      cd - &>/dev/null
      cd / &>/dev/null
    fi
    PROMPT="%{${ink[$name]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$unix_path]}%}%~%{${ink[$unix_Z]}%}%#${ink[reset]} %{${git_branch_info}%}"
  fi
  return
}
