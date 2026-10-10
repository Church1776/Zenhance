#!/usr/bin/zsh

# Z Shell easy color modifiers for changing the terminal_user prompt.
zit_user=${zit_user:-'208'}
zit_at=${zit_at:-'214'}
zit_mach=${zit_mach:-'228'}
zit_sys=${zit_sys:-'62'}
zit_unxpath=${zit_unxpath:-'35'}
zit_unxZ=${zit_unxZ:-'121'}
zit_winpath=${zit_winpath:-'33'}
zit_winZ=${zit_winZ:-'51'}
zit_vcs=${zit_vcs:-'245'}
zit_vcs2=${zit_vcs2:-'250'}
zit_vcs3=${zit_vcs3:-'reset'}
zit_colon=${zit_colon:-'245'}


# Check if in a git repository and grab the root directory for the precmd function.
zit_vcs_root=""
zit_vcs_data=""
zit_vcs_branch=""
zit_vcs_hash_length=""
zit_vcs_cmd_rerun=""
zit_cached_usystem=""
zit_cached_directory=""

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
unset ZIT_DEPENDANCIES
unset ZIT_CONFIGS
unset ZIT_USERHOME

NAME="${ZIT_TRUENAME:+$ZIT_TRUENAME}"
unset ZIT_TRUENAME
if [[ -z "$NAME" ]]; then
if [[ -e /etc/os-release ]]; then
    NAME=$(cat /etc/os-release | sed -n 's/^ID=\(.*\)$/\1/p')
elif [[ $usys == "Windows" ]]; then
    NAME=$(uname -o)
else
    NAME="$(uname)"
fi
fi
zit_vcs_root="$(git rev-parse --show-toplevel 2>/dev/null)"
(( $+functions[preexec] )) && unset -f preexec
function preexec {
    #echo "Preexec called with command: $1"
    if [[ $1 =~ "(^|[;|({])[[:space:]]*(git|fossil|svn)([[:space:]]*|[;|)}]|$)" ]]; then
        #echo "Setting zit_vcs_cmd_rerun..."
        zit_vcs_cmd_rerun=1
    fi
}
(( $+functions[precmd] )) || function precmd {}
function precmd {
    if [[ "$USYSTEM" != "$zit_cached_usystem" || -z "$USYSTEM" ]]; then
        if [[ -n $MSYSTEM ]]; then
            case $MSYSTEM in
                CLANG64)NAME='Clang64';;
                CLANGARM64)NAME='ClangArm64';;
                MINGW64)NAME='MinGW64';;
                MINGW32)NAME='MinGW32';;
                UCRT64)NAME='UCRT64';;
                MSYS)NAME='Msys';;
            esac
        fi
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
        path_color=$zit_unxpath
        Z_color=$zit_unxZ
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