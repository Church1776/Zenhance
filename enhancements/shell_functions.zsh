function cds {
	[[ -n $WHOME ]] || return
	case $usys in
		Msys) [[ $PWD == /[a-z] || $PWD == /[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
		Linux) [[ $PWD == /mnt/[a-z] || $PWD == /mnt/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
		Darwin) [[ $PWD == /Volumes/[a-z] || $PWD == /Volumes/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
		*BSD) [[ $PWD == /mnt/[a-z] || $PWD == /mnt/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
		DragonFly) [[ $PWD == /mnt/[a-z] || $PWD == /mnt/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
	esac
  if [[ $CHOME == $HOME ]]; then
    export CHOME=$WHOME
    cd $CHOME 
  else
    export CHOME=$HOME
    cd $CHOME
  fi
}