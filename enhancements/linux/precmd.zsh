#!/usr/bin/zsh

if [[ -z $READY_FOR_PRECMD || $READY_FOR_PRECMD != 1 ]]; then
  return
fi

unset cached_usystem
# Check for Linux system and grab the distro name for the precmd function.
if [[ $usys == 'Linux' ]]; then
  source /etc/os-release
  NAME="$NAME"
fi

USYSTEM=$NAME
UHOME=$HOME

# Check if inside a git repository and grab the root directory for the precmd function.
vcs_root="$(git rev-parse --show-toplevel 2>/dev/null)"

function preexec {
  #echo "Preexec called with command: $1"
  if [[ $1 =~ "(^|[;|({])[[:space:]]*(git|fossil|svn)([[:space:]]*|[;|)}]|$)" ]]; then
    #echo "Setting vcs_cmd_rerun..."
    vcs_cmd_rerun=1
  fi
}
function precmd {
  if [[ "$PWD" != "$cached_directory" ]]; then
    #echo "Directory changed to: $PWD"
    if [[ "$PWD/" == /mnt/[a-zA-Z]/* ]]; then
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
    if [[ -e "$PWD/.git" && "$PWD/.git" != "$vcs_root/.git" || "$PWD/" != "$vcs_root/"* ]]; then
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