#!/usr/bin/zsh

# Z Shell easy color modifiers for changing the terminal user prompt.
usys=$(uname ${MSYSTEM:+'-o'}) # If MSYSTEM exists: Use -o flag to get value 'Msys' to correctly express the desired configuration.
username=${username:-'208'}
AT=${AT:-'214'}
machine=${machine:-'228'}
system_env=${system_env:-'62'}
unix_path=${unix_path:-'35'}
unix_Z=${unix_Z:-'84'}
win32_path=${win32_path:-'33'}
win32_Z=${win32_Z:-'51'}
vcs_clr=${vcs_clr:-'245'}
vcs_cl2=${vcs_cl2:-'250'}
vcs_cl3=${vcs_cl3:-'reset'}
colon=${colon:-'245'}

# Cursor styles (uncomment one)
#printf '\e[0 q'         # Default (terminal-dependent)
#printf '\e[1 q'  # Blinking block
#printf '\e[2 q'         # Steady block
printf '\e[3 q'  # Blinking underline
#printf '\e[4 q'         # Steady underline
#printf '\e[5 q'  # Blinking bar (I-beam)
#printf '\e[6 q'         # Steady bar (recommended for modern terminals)

# Configure completion to be case insensitive.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

ZENHANCE="${${(%):-%N}:A:h}"
ZINITDIR=""

# Move to Zenhance directory for handling dependancy paths.
if [[ ! "$PWD" == "$ZENHANCE" ]]; then
  ZINITDIR="$PWD"
  cd "$ZENHANCE"
fi

# Check for Zsh RC file. If no file exists copy zshrc.zsh file to HOME/.zshrc. If HOME/.zshrc doesn't source this file, append a line for sourcing.
if [[ ! -s "$HOME/.zshrc" ]]; then
  cp "$ZENHANCE/zshrc.zsh" "$HOME/.zshrc";
fi
if [[ -r "$HOME/.zshrc" ]]; then
  while IFS= read -r line; do
    [[ $line == *zenhance.zsh* ]] || continue
    line="${line//source /}"
    [[ -f $line ]] && break
  done < "$HOME/.zshrc"
  [[ -f $line ]] || { print -r -- "source $ZENHANCE/zenhance.zsh" >> "$HOME/.zshrc"; }
fi
# Check for other packages needed to complete ZENHANCE setup.
source "$ZENHANCE/dependancies/setup.zsh"
source "$ZENHANCE/dependancies/validator.zsh"

# Configure Windows home directory. I'm Assuming the Windows environment is available to the User.
case $usys in
  Msys) WHOME=$(cygpath -u ${WINDIR%%\\*})/Users/$USER;;
  Linux) WHOME="$(find /mnt -maxdepth 2 -type d -name "Users" 2>/dev/null)"; WHOME="${WHOME:+$WHOME/$USER}";;
esac

# Initialize shell configurations relative to script's location.
configs=($(find "$ZENHANCE/enhancements/${(L)usys}" -type f -name '*.zsh'))
configs+=($(find "$ZENHANCE/enhancements" -maxdepth 1 -type f -name '*.zsh' ))
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

# Check if in a git repository and grab the root directory for the precmd function.
vcs_root=""
vcs_data=""
vcs_branch=""
vcs_hash_length=""
vcs_cmd_rerun=""
cached_usystem=""
cached_directory=""

# Return User to their original location and grab Pre-Command function for the prompt.
if [[ -n "$ZINITDIR" ]]; then
  cd "$ZINITDIR"
  unset ZINITDIR
fi

# Source post-enhance configurations.
source "$ZENHANCE/dependancies/post_enhance_configs.zsh"

READY_FOR_PRECMD=1
source "$(find $ZENHANCE/enhancements/${(L)usys} -type f -name 'precmd.zsh')"
unset READY_FOR_PRECMD