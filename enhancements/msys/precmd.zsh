#!/usr/bin/zsh

if [[ -z $READY_FOR_PRECMD || $READY_FOR_PRECMD != 1 ]]; then
  return
fi

# Grab MROOT not set by User, grab the msys2 root directory path for the precmd function.
if [[ -z $MROOT ]]; then
  MROOT="$(cygpath -m /)"
  MROOT="/${(L)MROOT//:/}"
  MROOT="${MROOT%/}"
fi

# Check if inside a git repository and grab the root directory for the precmd function.
vcs_root="$(git rev-parse --show-toplevel 2>/dev/null)"

USYSTEM=$MSYSTEM
UHOME=$HOME

function preexec {
  if [[ "$1" == *"git "* || "$1" == "git" ]]; then
    #echo "Git command detected: $1"
    vcs_cmd_rerun=1
  fi
}
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
    if [[ "$PWD" == /[a-zA-Z] && "$PWD" != "$MROOT" ]] && [[ "$PWD" == /[a-zA-Z]/* || "$PWD" != "$MROOT"/* && "$PWD" != "$MROOT"* ]]; then
      UHOME=$WHOME
      path_color=$win32_path
      Z_color=$win32_Z
    else
      UHOME=$HOME
      path_color=$unix_path
      Z_color=$unix_Z
      PWD="${PWD#$MROOT}"
      PWD=${PWD:-/}
    fi
    if [[ "$PWD" == ${vcs_root:+$vcs_root/*} && -e "$PWD/.git" || "$PWD" != ${vcs_root:+$vcs_root/*} && "$PWD" != ${vcs_root:+$vcs_root*} ]]; then
      #echo "Locating vcs_root..."
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
      #echo "Entering vcs_root..."
      if [[ ! -d "$vcs_root/.git" && -z $vcs_data ]]; then
        echo "Locating vcs_data..."
        read -r vcs_data < "$vcs_root/.git"
        vcs_data="${vcs_data#gitdir: }"
      fi
      vcs_data="${vcs_data:-$vcs_root/.git}"
      vcs_hash_length="$(git rev-parse --short HEAD 2>/dev/null)"
      vcs_hash_length=${#vcs_hash_length}
      if [[ -z $vcs_cmd_rerun ]]; then
        #echo "Setting vcs_cmd_rerun..."
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
      vcs_branch="HEAD%{${ink[$vcs_cl2]}%}@%{${ink[$vcs_cl3]}%}${vcs_branch:0:$vcs_hash_length}%{${ink[$vcs_clr]}%}"
    else
      vcs_branch="${vcs_branch#ref: refs/heads/}"
    fi
    vcs_branch="%{${ink[$vcs_clr]}%}($vcs_branch)%{${ink[reset]}%} "
  fi
  cached_directory="$PWD"
  PROMPT="%{${ink[$username]}%}%n%{${ink[$AT]}%}@%{${ink[$machine]}%}%m%{${ink[$colon]}%}:%{${ink[$system_env]}%}$USYSTEM%{${ink[$colon]}%}:%{${ink[$path_color]}%}${PWD/$UHOME/~}%{${ink[$Z_color]}%}%#%{${ink[reset]}%} ${vcs_branch}"
  return
}