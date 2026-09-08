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
#printf '\e[0 q'         # Default (terminal-dependent)
#printf '\e[1 q'  # Blinking block
#printf '\e[2 q'         # Steady block
printf '\e[3 q'  # Blinking underline
#printf '\e[4 q'         # Steady underline
#printf '\e[5 q'  # Blinking bar (I-beam)
#printf '\e[6 q'         # Steady bar (recommended for modern terminals)

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
vcs_cmd_rerun=""
cached_usystem=""
cached_directory=""


# Pre-Command Function for the prompt.
READY_FOR_PRECMD=1
source "$(find ${zenhance:A:h}/enhancements/${(L)usys} -type f -name 'precmd.zsh')"
#PROMPT="%{${ink[$username]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$MSYSTEM%{${ink[$colon]}%}:%{${ink[$unix_path]}%}~%{${ink[$unix_Z]}%}%#%{${ink[reset]}%} "
  