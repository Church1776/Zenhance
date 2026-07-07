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
  local userprograms="$(cygpath -u ${LOCALAPPDATA})/Programs"
  local vscode_bin_path="$userprograms/Microsoft VS Code/bin"
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

function vcpkgpath {
  local userprograms="$(cygpath -u ${LOCALAPPDATA})/Programs"
  local vcpkg_bin_path="$userprograms/vcpkg"
  if [[ $PATH == *"$vcpkg_bin_path"* ]]; then
      return
  fi
  PATH+=":$vcpkg_bin_path"
  export PATH="$PATH"
}
vcpkgpath
unset -f vcpkgpath

CC="clang"
CCSTD="c23"

CXX="clang++"
CXXSTD="c++23"
CXXSTDLIB="libc++"
CXXRTLIB="compiler-rt"
CXXUSELD="lld"
CXXINCLUDE=""

function find-include-folder {

  local REPO_ROOT="$(git rev-parse --show-toplevel 2> /dev/null)"

  if [[ -z $REPO_ROOT ]]; then
    return
  fi

  local TEMPPWD="$PWD"

  while [[ "$TEMPPWD" == "$REPO_ROOT"/* || "$TEMPPWD" == "$REPO_ROOT" ]]; do
    CXXINCLUDE="$(find "$TEMPPWD" -maxdepth 1 -type d -name "inc"* -print -quit)"
    if [[ -d "$CXXINCLUDE" ]]; then
      break
    fi
    TEMPPWD="${TEMPPWD:h}"
  done

  unset REPO_ROOT
  unset TEMPPWD
}
find-include-folder

export CC CCSTD CXX CXXSTD CXXSTDLIB CXXRTLIB CXXUSELD CXXINCLUDE
CXXFLAGS=()
LDLIBS=(-luser32 -lgdi32)

export CXXFLAGS
export LDLIBS

function ccpl {
  $CC -std=$CCSTD -I$CXXINCLUDE "$@" ${LDLIBS[@]}
}

function cxxpl {
  $CXX -std=$CXXSTD -stdlib=$CXXSTDLIB -rtlib=$CXXRTLIB -fuse-ld=$CXXUSELD -I$CXXINCLUDE ${CXXFLAGS[@]} "$@" ${LDLIBS[@]}
}

function set_cpl {
  
  case "$1" in
    c|C) alias cpl=ccpl;;
    c++|C++|cxx|CXX|cpp|CPP) alias cpl=cxxpl;;
    *) echo "set_cpl: Unknown Argument: '$1'"
      echo "set_cpl: Available options: c, C, c++, C++, cxx, CXX, cpp, CPP"
      ;;
  esac

  if [[ -z $(alias cpl 2>/dev/null) ]]; then
    alias cpl=cxxpl
  fi
}
set_cpl C++
