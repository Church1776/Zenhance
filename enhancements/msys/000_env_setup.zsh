if [[ -z $MSYSTEM ]]; then 
  return
fi

function localtools {
  if [[ $MSYSTEM == 'MSYS' ]]; then
    return
  fi
  
  local msys_env_bin="/${(L)MSYSTEM}/bin"
  local msys_env_local_bin="/${(L)MSYSTEM}/local/bin"
  
  if [[ $PATH == *"$msys_env_local_bin"* ]]; then
      return
  fi
  if [[ ! -d $msys_env_local_bin ]]; then
      mkdir -p $msys_env_local_bin
  fi    
  PATH="${PATH//${msys_env_bin}:/${msys_env_local_bin}:${msys_env_bin}:}"
  export PATH="$PATH"
}
localtools
unset -f localtools

function vscodepath {
  local user="$(cygpath -u $USERPROFILE)"
  local vscode_bin_path="$user/AppData/Local/Programs/Microsoft VS Code/bin"
  if [[ $PATH == *"$vscode_bin_path"* ]]; then
      return
  fi
  PATH+=":$vscode_bin_path"
  export PATH="$PATH"
}
vscodepath
unset -f vscodepath

function javapath {
  local program="$(cygpath -u $PROGRAMFILES)"
  local java_bin_path="$program/Common Files/Oracle/Java/javapath"
  if [[ $PATH == *"$java_bin_path"* ]]; then
      return
  fi
  PATH+=":$java_bin_path"
  export PATH="$PATH"
}
javapath
unset -f javapath

CC="clang"
CCSTD="c23"

CXX="clang++"
CXXSTD="c++23"
CXXSTDLIB="libc++"
CXXRTLIB="compiler-rt"
CXXUSELD="lld"

function incfinder {
REPO_ROOT="$(git rev-parse --show-toplevel 2> /dev/null)"

TEMPPWD="$PWD"

while [[ "$TEMPPWD" == "$REPO_ROOT/*" || "$TEMPPWD" == "$REPO_ROOT" ]]; do
  printf "Checking \033[33m$TEMPPWD\033[0m for inc directory...\n"
  CXXINCLUDE="$(find "$TEMPPWD" -maxdepth 1 -type d -name "inc"* -print -quit)"
  if [[ -d "$CXXINCLUDE" ]]; then
    printf "Found inc directory at \033[32m$CXXINCLUDE\033[0m\n"
  fi
  TEMPPWD="${TEMPPWD:h}"
done

unset REPO_ROOT
unset TEMPPWD
}
incfinder

export CC CCSTD CXX CXXSTD CXXSTDLIB CXXRTLIB CXXUSELD CXXINCLUDE

WINLIBS=(-luser32 -lgdi32)

export WINLIBS

function ccmpl {
  $CC -std=$CCSTD -I$CXXINCLUDE "$@" ${WINLIBS[@]}
}

function cxxcmpl {
  $CXX -std=$CXXSTD -stdlib=$CXXSTDLIB -rtlib=$CXXRTLIB -fuse-ld=$CXXUSELD -I$CXXINCLUDE "$@" ${WINLIBS[@]}
}

function set_cmpl {
  
  case "$1" in
    c|C) alias cmpl=ccmpl;;
    c++|C++|cxx|CXX|cpp|CPP) alias cmpl=cxxcmpl;;
    *) echo "Unknown Argument: $1"
      echo "Available options: c, C, c++, C++, cxx, CXX, cpp, CPP"
      ;;
  esac

  if [[ -z $(alias cmpl 2>/dev/null) ]]; then
    alias cmpl=cxxcmpl
  fi
}
set_cmpl

