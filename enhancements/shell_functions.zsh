function cds {
  if [[ -e $CHOME ]]; then
    if [[ $PWD == '/mnt/'[a-z] || $PWD == '/mnt/'[a-z]/* || $PWD == '/mnt/windows' ]]; then
      export CHOME="$WHOME"
    elif [[ $PWD == '/'[a-z]/* && $usys == 'Msys' || $PWD == '/'[a-z] && $usys == 'Msys' ]]; then
      export CHOME="$WHOME"
    else
      export CHOME="$HOME"
    fi
  fi
  if [[ $CHOME == $HOME ]]; then
    export CHOME="$WHOME"
    cd $CHOME 
  else
    export CHOME="$HOME"
    cd $CHOME
  fi
}