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