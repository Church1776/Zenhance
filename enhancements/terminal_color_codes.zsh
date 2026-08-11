typeset -gA ink=(
  black           $'\033[30m'
  red             $'\033[31m'
  green           $'\033[32m'
  yellow          $'\033[33m'
  blue            $'\033[34m'
  magenta         $'\033[35m'
  cyan            $'\033[36m'
  white           $'\033[37m'
  brightblack     $'\033[90m'
  brightred       $'\033[91m'
  brightgreen     $'\033[92m'
  brightyellow    $'\033[93m'
  brightblue      $'\033[94m'
  brightmagenta   $'\033[95m'
  brightcyan      $'\033[96m'
  brightwhite     $'\033[97m'
  gray            $'\033[38;5;244m'
  coral           $'\033[38;5;203m'
  forest          $'\033[38;5;34m'
  gold            $'\033[38;5;220m'
  cerulean        $'\033[38;5;39m'
  periwinkle      $'\033[38;5;141m'
  lightgray       $'\033[38;5;250m'
  darkgray        $'\033[38;5;240m'
  orange          $'\033[38;5;208m'
  purple          $'\033[38;5;135m'
  lightorange     $'\033[38;5;228m'
  pink            $'\033[38;5;205m'
  brown           $'\033[38;5;94m'
  brightgold      $'\033[38;5;227m'
  brightergold    $'\033[38;5;228m'
  cyanblue        $'\033[38;5;38m'
  teal            $'\033[38;5;30m'
  tealblue        $'\033[38;5;37m'
  turquoise       $'\033[38;5;35m'
  mint            $'\033[38;5;121m'
  olive           $'\033[38;5;142m'
  navy            $'\033[38;5;17m'
  maroon          $'\033[38;5;124m'
  lavender        $'\033[38;5;225m'
  vanilla         $'\033[38;5;229m'
  beige           $'\033[38;5;230m'
  salmon          $'\033[38;5;209m'
  skyblue         $'\033[38;5;117m'
  rose            $'\033[38;5;213m'
  peach           $'\033[38;5;216m'
  burgundy        $'\033[38;5;131m'
  amber           $'\033[38;5;214m'
  sepia           $'\033[38;5;130m'
  slateblue       $'\033[38;5;62m'
  olivegreen      $'\033[38;5;100m'
  rosepink        $'\033[38;5;218m'
  brightrosepink  $'\033[38;5;219m'
  skybluebright   $'\033[38;5;123m'
  brighterskyblue $'\033[38;5;159m'
  reset           $'\033[0m'
)

function shcolors {
  if [[ -z $ink ]]; then
    echo ":[info]: No colors found."
    return
  fi
  echo "Colors loaded:"
  for color in ${(ok)ink}; do
    echo -e "${ink[gray]}: ${ink[$color]}$color${ink[reset]}"
  done
  echo ""
}