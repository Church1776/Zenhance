#!/bin/zsh
0="${(%):-%N}" &>/dev/null

# Grab the msys2 root path for later use.
if [[ -n $MSYSTEM ]]; then
  mdrv=''
  cd / &>/dev/null
  MROOT="$(cygpath -m "$PWD")"
  MROOT="/${(L)MROOT//:/}"
  MROOT="${MROOT%/}"
  cd - &>/dev/null
fi
unset mdrv

# Configure home directories.
MNT=''
if [[ -n $WSL_DISTRO || -n $WSL_DISTRO_NAME ]]; then
  MNT='/mnt'
fi
MHOME="${MNT}${MROOT}/home/$USER"
WHOME="$MNT/c/Users/$USER"
UHOME="/home/$USER"
unset MNT

# Z Shell easy color modifiers for changing the terminal user prompt.
source /etc/os-release &>/dev/null
if [[ -n $MSYSTEM ]]; then
  usys=${MSYSTEM[1]}${MSYSTEM[2,-1]:l}
  name='turquoise'
  at_symbol='brightgreen'
  machine='mint'
  system_env='periwinkle'
  unix_path='gold'
  unix_Z='brightergold'
elif [[ -n $WSL_DISTRO_NAME || -n $WSL_DISTRO ]]; then
  usys=$NAME
  name='orange'
  at_symbol='amber'
  machine='lightorange'
  system_env='slateblue'
  unix_path='turquoise'
  unix_Z='mint'
fi
win32_path='cerulean'
win32_Z='brighterskyblue'
vcs_branch='gray'
colon_color='gray'

### Custom commands for the shell environment.
function showcolors {
  if [[ -z $ink ]]; then
    echo ":[info]: No colors found."
    return
  fi
  echo "Colors loaded:"
  for color in ${(ok)ink}; do
    echo -e "${ink[gray]}: ${ink[$color]}$color${ink[reset]}"
  done
  echo ""
}
#echo ":[added]: Command: showcolors - Displays loaded colors for the terminal."

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
configs=($(find ${0:A:h}/enhancements -type f -name '*.zsh'))
if [[ -n $configs ]]; then
  for config in ${(@o)configs[@]}; do
    if [[ ! -f $config || $config == *.zsh*msys* && -z $MSYSTEM || $config == *.zsh*wsl* && -z $WSL_DISTRO_NAME && -z $WSL_DISTRO ]]; then
      continue
    fi
    source $config
    #echo ":[loaded]: ~${config#"$MHOME/"}"
  done
fi

# Display Home paths.
function display_homes {
  if [[ -n $MSYSTEM ]]; then
    echo "Configuring ${ink[$unix_path]}$usys${ink[reset]}|${ink[$win32_path]}Windows${ink[reset]} homes for ${ink[$name]}$USER${ink[reset]}."
    echo -e "${ink[$system_env]}:[$usys]: ${ink[$unix_path]}${UHOME%$USER}${ink[$name]}$USER${ink[reset]}"
  elif [[ -n $WSL_DISTRO_NAME || -n $WSL_DISTRO ]]; then
    echo "Configuring ${ink[$unix_path]}$usys${ink[reset]}|${ink[$win32_path]}Windows${ink[reset]} homes for ${ink[$name]}$USER${ink[reset]}."
    echo -e "${ink[$system_env]}:[$usys]: ${ink[$unix_path]}${UHOME%$USER}${ink[$name]}$USER${ink[reset]}"
  fi
  echo -e "${ink[$system_env]}:[Windows]: ${ink[$win32_path]}${WHOME%$USER}${ink[$name]}$USER${ink[reset]}"
}

# Pre-Command Function for the prompt.
function precmd {
  if [[ -n $MSYSTEM ]]; then
    USYSTEM="$MSYSTEM"
  elif [[ -n $WSL_DISTRO_NAME ]]; then
    USYSTEM="$WSL_DISTRO_NAME"
  fi
  if git_branch_info="$(git branch --show-current 2>/dev/null)" && [[ -z $git_branch_info ]]; then
    git_branch_info="HEAD@$(git rev-parse --short HEAD 2>/dev/null)"
  fi
  if [[ -n $git_branch_info ]]; then
    git_branch_info="%{${ink[$vcs_branch]}%}($git_branch_info)%{${ink[reset]}%}%f "
  fi
  if [[ $PWD == "/"[a-z] && -n $MSYSTEM && $PWD != ${MROOT}* || $PWD == "/"[a-z]/* && -n $MSYSTEM && $PWD != ${MROOT}* || $PWD == "/mnt/"[a-z] && -n $WSL_DISTRO_NAME || $PWD == "/mnt/"[a-z]/* && -n $WSL_DISTRO_NAME ]]; then
    PROMPT="%{${ink[$name]}%}%n%{${ink[$at_symbol]}%}@%{${ink[$machine]}%}%m%{${ink[$colon_color]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon_color]}%}:%{${ink[$win32_path]}%}${PWD/$WHOME/~}%{${ink[$win32_Z]}%}%#${ink[reset]} %{${git_branch_info}%}"
  else
    if [[ $PWD == $MROOT* && -n $MSYSTEM ]]; then
      cd - &>/dev/null
      cd / &>/dev/null
    fi
    PROMPT="%{${ink[$name]}%}%n%{${ink[$at_symbol]}%}@%{${ink[$machine]}%}%m%{${ink[$colon_color]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon_color]}%}:%{${ink[$unix_path]}%}%~%{${ink[$unix_Z]}%}%#${ink[reset]} %{${git_branch_info}%}"
  fi
  return
}
