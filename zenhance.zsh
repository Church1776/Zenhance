#!/bin/zsh
0="${(%):-%N}" &>/dev/null

# Z Shell easy color modifiers for changing the terminal user prompt.
usys=$(uname ${MSYSTEM:+'-o'}) # Check for MSYS2 environment to use 'Msys' for certain display functions.
name=${name:-'orange'}
AT=${AT:-'amber'}
machine=${machine:-'lightorange'}
system_env=${system_env:-'slateblue'}
unix_path=${unix_path:-'turquoise'}
unix_Z=${unix_Z:-'mint'}
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
MNT='/mnt'

# Grab the msys2 root path for later use.
if [[ -n $MSYSTEM ]]; then
  unset MNT
  cd / &>/dev/null
  MROOT="$(cygpath -m "$PWD")"
  MROOT="/${(L)MROOT//:/}"
  MROOT="${MROOT%/}"
  cd - &>/dev/null
fi

# Configure Windows home directory.
WHOME="$(find $MNT/c -maxdepth 2 -type d -name "$USER" 2>/dev/null)"
# Display Home paths.
function shuser {
  echo "Home directories for ${ink[$name]}$USER${ink[reset]} on ${ink[$unix_path]}$usys${ink[reset]}|${ink[$win32_path]}Windows${ink[reset]}."
  echo -e "${ink[$system_env]}:[$usys]: ${ink[$unix_path]}${HOME%$USER}${ink[$name]}$USER${ink[reset]}"
  echo -e "${ink[$system_env]}:[Windows]: ${ink[$win32_path]}${WHOME%$USER}${ink[$name]}$USER${ink[reset]}"
}

# Pre-Command Function for the prompt.
function precmd {
  if [[ -n $MSYSTEM ]]; then
    case $MSYSTEM in
      CLANG64)USYSTEM='Clang64';;
      CLANGARM64)USYSTEM='ClangArm64';;
      MINGW64)USYSTEM='MinGW64';;
      MINGW32)USYSTEM='MinGW32';;
      UCRT64)USYSTEM='UCRT64';;
      MSYS)USYSTEM='MSYS';;
    esac
  else
    USYSTEM="$NAME"
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
