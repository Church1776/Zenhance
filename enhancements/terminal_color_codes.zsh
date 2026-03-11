typeset -gA ink=(
  black           $'\e[30m'
  red             $'\e[31m'
  green           $'\e[32m'
  yellow          $'\e[33m'
  blue            $'\e[34m'
  magenta         $'\e[35m'
  cyan            $'\e[36m'
  white           $'\e[37m'
  brightblack     $'\e[90m'
  brightred       $'\e[91m'
  brightgreen     $'\e[92m'
  brightyellow    $'\e[93m'
  brightblue      $'\e[94m'
  brightmagenta   $'\e[95m'
  brightcyan      $'\e[96m'
  brightwhite     $'\e[97m'
  gray            $'\e[38;5;244m'
  coral           $'\e[38;5;203m'
  forest          $'\e[38;5;34m'
  gold            $'\e[38;5;220m'
  cerulean        $'\e[38;5;39m'
  periwinkle      $'\e[38;5;141m'
  lightgray       $'\e[38;5;250m'
  darkgray        $'\e[38;5;240m'
  orange          $'\e[38;5;208m'
  purple          $'\e[38;5;135m'
  lightorange     $'\e[38;5;228m'
  pink            $'\e[38;5;205m'
  brown           $'\e[38;5;94m'
  brightgold      $'\e[38;5;227m'
  brightergold    $'\e[38;5;228m'
  cyanblue        $'\e[38;5;38m'
  teal            $'\e[38;5;30m'
  tealblue        $'\e[38;5;37m'
  turquoise       $'\e[38;5;35m'
  mint            $'\e[38;5;121m'
  olive           $'\e[38;5;142m'
  navy            $'\e[38;5;17m'
  maroon          $'\e[38;5;124m'
  lavender        $'\e[38;5;225m'
  beige           $'\e[38;5;230m'
  salmon          $'\e[38;5;209m'
  skyblue         $'\e[38;5;117m'
  rose            $'\e[38;5;213m'
  peach           $'\e[38;5;216m'
  burgundy        $'\e[38;5;131m'
  amber           $'\e[38;5;214m'
  sepia           $'\e[38;5;130m'
  slateblue       $'\e[38;5;62m'
  olivegreen      $'\e[38;5;100m'
  rosepink        $'\e[38;5;218m'
  brightrosepink  $'\e[38;5;219m'
  skybluebright   $'\e[38;5;123m'
  brighterskyblue $'\e[38;5;159m'
  reset           $'\e[0m'
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