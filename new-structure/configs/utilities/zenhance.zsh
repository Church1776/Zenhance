(( $+functions[zenhance] )) && return
function zenhance {
  args=("$@")
  [[ -z $args ]] && { echo "No arguments passed.";}
}