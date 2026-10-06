#!/usr/bin/zsh

# Z Shell easy color modifiers for changing the terminal_user prompt.
zit_user=${zit_user:-'208'}
zit_at=${zit_at:-'214'}
zit_mach=${zit_mach:-'228'}
zit_sys=${zit_sys:-'62'}
zit_nixpath=${zit_nixpath:-'35'}
zit_nixZ=${zit_nixZ:-'121'}
zit_winpath=${zit_winpath:-'33'}
zit_winZ=${zit_winZ:-'51'}
zit_vcs=${zit_vcs:-'245'}
zit_vcs2=${zit_vcs2:-'250'}
zit_vcs3=${zit_vcs3:-'reset'}
zit_colon=${zit_colon:-'245'}

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

ZIT_LOCATION="${${(%):-%N}:A:h}"
ZIT_INITDIR=""

# Move to Zenhance directory for handling dependancy paths.
if [[ ! "$PWD" == "$ZIT_LOCATION" ]]; then
  ZIT_INITDIR="$PWD"
  cd "$ZIT_LOCATION"
fi
# Check for Zsh RC file. If no file exists copy zshrc.zsh file to HOME/.zshrc. If HOME/.zshrc doesn't source this file, append a line for sourcing.
if [[ ! -s "$HOME/.zshrc" ]]; then
  cp "$ZIT_LOCATION/zshrc.zsh" "$HOME/.zshrc";
fi
if [[ -r "$HOME/.zshrc" ]]; then
  while IFS= read -r line; do
    [[ $line == *zenhance.zsh* ]] || continue
    line="${line//source /}"
    [[ -f $line ]] && { break; }
  done < "$HOME/.zshrc"
  [[ -f $line ]] || { print -r -- "source $ZIT_LOCATION/zenhance.zsh" >> "$HOME/.zshrc"; }
fi

# Check for other packages needed to complete ZIT_LOCATION setup.
source "$ZIT_LOCATION/dependancies/setup.zsh"
source "$ZIT_LOCATION/dependancies/validator.zsh"

# Configure Windows home directory. I'm Assuming the Windows environment is available to the User.
# If Windows environment is not available, no errors are thrown. Nothing special needs to be done.
# This is only to resolve the main environment folders. Distributions will be resolved within each folder separately.
if (( $+commands[cygpath] )); then
  usys="Windows"
else
  source /etc/os-release
  usys="$(uname)"
  if [[ $usys =~ ^.*BSD$ ]]; then
    usys="BSD"
  fi
fi
case $usys in
  Windows) WHOME=$(cygpath -u ${WINDIR%%\\*})/Users/$USER;;
  Linux) WHOME="$(find /mnt -maxdepth 2 -type d -name "Users" 2>/dev/null)"; WHOME="${WHOME:+$WHOME/$USER}";;
  Darwin) WHOME="$(find /mnt -maxdepth 2 -type d -name "Users" 2>/dev/null)"; WHOME="${WHOME:+$WHOME/$USER}";;
  BSD) WHOME="$(find /mnt -maxdepth 2 -type d -name "Users" 2>/dev/null)"; WHOME="${WHOME:+$WHOME/$USER}";;
esac

# Initialize shell configurations relative to script's location.
function load_configs {
  local configs=()
  configs=($(find "$ZIT_LOCATION/enhancements/${(L)usys}" -maxdepth 1 -type f -name '*.zsh'))
  configs+=($(find "$ZIT_LOCATION/enhancements" -maxdepth 1 -type f -name '*.zsh' ))
  if [[ -n $configs ]]; then
    for config in ${(@)configs[@]}; do
      echo "Loading config: $config"
      [[ -f $config ]] && source $config
    done
  fi
}
#load_configs
load_configs

# Display Shell User paths.
function shuser {
  local unixuser=""
  if [[ $usys == "Windows" ]]; then
    unixuser=$(uname -o)
  else
    unixuser="$(uname)"
  fi
  echo "Home directories found for ${ink[$zit_user]}$USER${ink[reset]}: ${ink[$zit_nixpath]}${unixuser}${ink[reset]}${WHOME:+|}${ink[$zit_winpath]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$zit_sys]}:[$unixuser]: ${ink[$zit_nixpath]}${HOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$zit_sys]}:[Windows]: ${ink[$zit_winpath]}${WHOME%$USER}${ink[$zit_user]}$USER${ink[reset]}"
}

# Check if in a git repository and grab the root directory for the precmd function.
zit_vcs_root=""
zit_vcs_data=""
zit_vcs_branch=""
zit_vcs_hash_length=""
zit_vcs_cmd_rerun=""
zit_cached_usystem=""
zit_cached_directory=""

# Return User to their original location and grab Pre-Command function for the prompt.
if [[ -n "$ZIT_INITDIR" ]]; then
  cd "$ZIT_INITDIR"
  unset ZIT_INITDIR
fi

# Source post-enhance configurations.
source "$ZIT_LOCATION/dependancies/post_enhance_configs.zsh"

READY_FOR_PRECMD=1
if [[ $usys == "Windows" ]]; then
  subsys="$(uname -o)"
  #source "$(find $ZIT_LOCATION/enhancements/${(L)usys}/${(L)subsys} -type f -name 'precmd.zsh')"
  unset subsys
else
  #source "$(find "$ZIT_LOCATION/enhancements/${(L)usys}" -maxdepth 1 -name '*.zsh')"
fi
unset READY_FOR_PRECMD

function setprefuncs {
  source /etc/os-release
  USYSTEM=$NAME
  zit_vcs_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  (( $+functions[preexec] )) && unset -f preexec
  function preexec {
    #echo "Preexec called with command: $1"
    if [[ $1 =~ "(^|[;|({])[[:space:]]*(git|fossil|svn)([[:space:]]*|[;|)}]|$)" ]]; then
      #echo "Setting zit_vcs_cmd_rerun..."
      zit_vcs_cmd_rerun=1
    fi
  }
  (( $+functions[precmd] )) && unset -f precmd
  function precmd {
    if [[ "$USYSTEM" != "$zit_cached_usystem" ]]; then
        case $MSYSTEM in
          CLANG64)NAME='Clang64';;
          CLANGARM64)NAME='ClangArm64';;
          MINGW64)NAME='MinGW64';;
          MINGW32)NAME='MinGW32';;
          UCRT64)NAME='UCRT64';;
          MSYS)NAME='Msys';;
        esac
        USYSTEM="${NAME:-$usys}"
        zit_cached_usystem="$USYSTEM"
    fi
    if [[ "$PWD" != "$zit_cached_directory" ]]; then
      if [[ "$PWD/" == /[a-zA-Z]/* && "$PWD/" != "$MROOT/"* ]]; then
        UHOME=$WHOME
        path_color=$zit_winpath
        Z_color=$zwinZ
      else
        UHOME=$HOME
        path_color=$zit_nixpath
        Z_color=$zit_nixZ
        PWD="${PWD#$MROOT}"
        PWD=${PWD:-/}
      fi
      if [[ -e "$PWD/.git" && "$PWD/.git" != "$zit_vcs_root/.git" || "$PWD/" != "$zit_vcs_root/"* || -z "$zit_vcs_root" ]]; then
        #echo "Updating zit_vcs_root..."
        zit_vcs_root=""
        zit_vcs_data=""
        zit_vcs_branch=""
        zit_vcs_hash_length=""
        local tempPWD=$PWD
        while [[ -n "$tempPWD" && "$tempPWD" != "/" ]]; do
          if [[ ! -e "$tempPWD/.git" ]]; then
            tempPWD="${tempPWD:h}"
            continue
          fi
          zit_vcs_root="$tempPWD"
          break
        done
      fi
      if [[ -z $zit_vcs_data && -n $zit_vcs_root ]]; then
        if [[ ! -d "$zit_vcs_root/.git" && -z $zit_vcs_data ]]; then
          #echo "Locating zit_vcs_data..."
          read -r zit_vcs_data < "$zit_vcs_root/.git"
          zit_vcs_data="${zit_vcs_data#gitdir: }"
        fi
        zit_vcs_data="${zit_vcs_data:-$zit_vcs_root/.git}"
        zit_vcs_hash_length="$(git rev-parse --short HEAD 2>/dev/null)"
        zit_vcs_hash_length=${#zit_vcs_hash_length}
        if [[ -z $zit_vcs_cmd_rerun ]]; then
          #echo "Initializing zit_vcs_cmd_rerun..."
          zit_vcs_cmd_rerun=1
        fi
      fi
    fi
    #if [[ -n $zit_vcs_data ]]; then
    if [[ -n $zit_vcs_data  && -n $zit_vcs_cmd_rerun ]]; then
      zit_vcs_cmd_rerun=""
      #echo "Reading zit_vcs_data..."
      read -r zit_vcs_branch < "$zit_vcs_data/HEAD"
      if [[ $zit_vcs_branch != ref:\ refs/heads/* ]]; then
        zit_vcs_branch="HEAD%{${ink[$zvcs2]}%}@%{${ink[$zvcs3]}%}${zit_vcs_branch:0:$zit_vcs_hash_length}%{${ink[$zit_vcs]}%}"
      else
        zit_vcs_branch="${zit_vcs_branch#ref: refs/heads/}"
      fi
      zit_vcs_branch="%{${ink[$zit_vcs]}%}($zit_vcs_branch)%{${ink[reset]}%} "
    fi
    zit_cached_directory="$PWD"
    PROMPT="%{${ink[$zit_user]}%}%n%{${ink[$zit_at]}%}@%{${ink[$zit_mach]}%}%m%{${ink[$zit_colon]}%}:%{${ink[$zit_sys]}%}$USYSTEM%{${ink[$zit_colon]}%}:%{${ink[$path_color]}%}${PWD/$UHOME/~}%{${ink[$Z_color]}%}%#%{${ink[reset]}%} ${zit_vcs_branch}"
    return
  }
}
setprefuncs
unset -f setprefuncs
