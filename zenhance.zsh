#!/usr/bin/zsh

# Z Shell easy color modifiers for changing the terminal user prompt.
zuser=${zuser:-'208'}
zat=${zat:-'214'}
zmach=${zmach:-'228'}
zsys=${zsys:-'62'}
znixpath=${znixpath:-'35'}
znixZ=${znixZ:-'84'}
zwinpath=${zwinpath:-'33'}
zwinZ=${zwinZ:-'51'}
zvcs=${zvcs:-'245'}
zvcs2=${zvcs2:-'250'}
zvcs3=${zvcs3:-'reset'}
zcolon=${zcolon:-'245'}

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
  configs=($(find "$ZENHANCE/enhancements/${(L)usys}" -maxdepth 1 -type f -name '*.zsh'))
  configs+=($(find "$ZENHANCE/enhancements" -maxdepth 1 -type f -name '*.zsh' ))
  if [[ -n $configs ]]; then
    for config in ${(@)configs[@]}; do
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
  echo "Home directories found for ${ink[$zuser]}$USER${ink[reset]}: ${ink[$znixpath]}${unixuser}${ink[reset]}${WHOME:+|}${ink[$zwinpath]}${WHOME:+Windows}${ink[reset]}."
  echo -e "${ink[$zsys]}:[$unixuser]: ${ink[$znixpath]}${HOME%$USER}${ink[$zuser]}$USER${ink[reset]}"
  [[ -n $WHOME ]] || return
  echo -e "${ink[$zsys]}:[Windows]: ${ink[$zwinpath]}${WHOME%$USER}${ink[$zuser]}$USER${ink[reset]}"
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
if [[ $usys == "Windows" ]]; then
  subsys="$(uname -o)"
  source "$(find $ZENHANCE/enhancements/${(L)usys}/${(L)subsys} -type f -name 'precmd.zsh')"
  unset subsys
else
  source "$(find "$ZENHANCE/enhancements/${(L)usys}" -maxdepth 1 -name '*.zsh')"
fi
unset READY_FOR_PRECMD

function setprefuncs {
  source /etc/os-release
  USYSTEM=$NAME
  vcs_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  (( $+functions[preexec] )) && unset -f preexec
  function preexec {
    #echo "Preexec called with command: $1"
    if [[ $1 =~ "(^|[;|({])[[:space:]]*(git|fossil|svn)([[:space:]]*|[;|)}]|$)" ]]; then
      #echo "Setting vcs_cmd_rerun..."
      vcs_cmd_rerun=1
    fi
  }
  (( $+functions[precmd] )) && unset -f precmd
  function precmd {
    if [[ "$USYSTEM" != "$cached_usystem" ]]; then
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
    if [[ "$PWD" != "$cached_directory" ]]; then
      if [[ "$PWD/" == /[a-zA-Z]/* && "$PWD/" != "$MROOT/"* ]]; then
        UHOME=$WHOME
        path_color=$zwinpath
        Z_color=$zwinZ
      else
        UHOME=$HOME
        path_color=$znixpath
        Z_color=$znixZ
        PWD="${PWD#$MROOT}"
        PWD=${PWD:-/}
      fi
      if [[ -e "$PWD/.git" && "$PWD/.git" != "$vcs_root/.git" || "$PWD/" != "$vcs_root/"* || -z "$vcs_root" ]]; then
        #echo "Updating vcs_root..."
        vcs_root=""
        vcs_data=""
        vcs_branch=""
        vcs_hash_length=""
        local tempPWD=$PWD
        while [[ -n "$tempPWD" && "$tempPWD" != "/" ]]; do
          if [[ ! -e "$tempPWD/.git" ]]; then
            tempPWD="${tempPWD:h}"
            continue
          fi
          vcs_root="$tempPWD"
          break
        done
      fi
      if [[ -z $vcs_data && -n $vcs_root ]]; then
        if [[ ! -d "$vcs_root/.git" && -z $vcs_data ]]; then
          #echo "Locating vcs_data..."
          read -r vcs_data < "$vcs_root/.git"
          vcs_data="${vcs_data#gitdir: }"
        fi
        vcs_data="${vcs_data:-$vcs_root/.git}"
        vcs_hash_length="$(git rev-parse --short HEAD 2>/dev/null)"
        vcs_hash_length=${#vcs_hash_length}
        if [[ -z $vcs_cmd_rerun ]]; then
          #echo "Initializing vcs_cmd_rerun..."
          vcs_cmd_rerun=1
        fi
      fi
    fi
    #if [[ -n $vcs_data ]]; then
    if [[ -n $vcs_data  && -n $vcs_cmd_rerun ]]; then
      vcs_cmd_rerun=""
      #echo "Reading vcs_data..."
      read -r vcs_branch < "$vcs_data/HEAD"
      if [[ $vcs_branch != ref:\ refs/heads/* ]]; then
        vcs_branch="HEAD%{${ink[$zvcs2]}%}@%{${ink[$zvcs3]}%}${vcs_branch:0:$vcs_hash_length}%{${ink[$zvcs]}%}"
      else
        vcs_branch="${vcs_branch#ref: refs/heads/}"
      fi
      vcs_branch="%{${ink[$zvcs]}%}($vcs_branch)%{${ink[reset]}%} "
    fi
    cached_directory="$PWD"
    PROMPT="%{${ink[$zuser]}%}%n%{${ink[$zat]}%}@%{${ink[$zmach]}%}%m%{${ink[$zcolon]}%}:%{${ink[$zsys]}%}$USYSTEM%{${ink[$zcolon]}%}:%{${ink[$path_color]}%}${PWD/$UHOME/~}%{${ink[$Z_color]}%}%#%{${ink[reset]}%} ${vcs_branch}"
    return
  }
}
setprefuncs
unset -f setprefuncs