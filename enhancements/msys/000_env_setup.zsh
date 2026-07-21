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
LDLIBS=()

export CXXFLAGS
export LDLIBS

function addlib {
  local libs_to_add=("$@")
  for lib in "${libs_to_add[@]}"; do
    if [[ ! -f $(which ${lib//-l/}.dll) ]]; then
      continue
    fi
    if [[ $lib != "-l"* ]]; then
      lib="-l$lib"
    fi
    LDLIBS+=("$lib")
  done
}
function removelib {
  local libs_to_remove=("$@")
  for lib in "${libs_to_remove[@]}"; do
    if [[ $lib != "-l"* ]]; then
      lib="-l$lib"
    fi
    for (( i=1; i<${#LDLIBS[@]}; i++ )); do
      if [[ "${LDLIBS[$i]}" == "$lib" ]]; then
        unset 'LDLIBS[$i]'
        LDLIBS[$i]=()
      fi
    done
  done
}

function showlibs {
  for lib in "${LDLIBS[@]}"; do
    echo "$lib"
  done
}

function addipath {
  local args=("$@")
  for a in "${args[@]}"; do
    if [[ ! -d $a ]]; then
      continue
    fi
    a="-I$(realpath $a)"
    CXXINCLUDE+=("$a")
    done
}

function removeipath {
  local args=("$@")
  for a in "${args[@]}"; do
    if [[ ! -d $a ]]; then
      continue
    fi
    a="-I$(realpath $a)"
  CXXINCLUDE+=("$a")
  done
}

function ccompile {
  $CC -std=$CCSTD -I$CXXINCLUDE "$@" ${LDLIBS[@]}
}

function cxxcompile {
  $CXX ${CXXSTD:+"-std=$CXXSTD"} ${CXXSTDLIB:+"-stdlib=$CXXSTDLIB"} ${CXXRTLIB:+"-rtlib=$CXXRTLIB"} ${CXXUSELD:+"-fuse-ld=$CXXUSELD"} ${CXXINCLUDE} ${CXXFLAGS[@]} -c "$@" ${LDLIBS[@]}
}

function clink {
  $CXX -std=${CXXSTD} -stdlib=${CXXSTDLIB} -rtlib=${CXXRTLIB} -fuse-ld=${CXXUSELD} "$@" ${LDLIBS[@]}
}

function setcompile {
  
  case "$1" in
    c|C) alias compile=ccompile;;
    c++|C++|cxx|CXX|cpp|CPP) alias compile=cxxcompile;;
    *) echo "set_cpl: Unknown Argument: '$1'"
      echo "set_cpl: Available options: c, C, c++, C++, cxx, CXX, cpp, CPP"
      ;;
  esac
}

if [[ -z $(alias compile 2>/dev/null) ]]; then
  alias compile=cxxcompile
fi
