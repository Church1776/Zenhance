# The Pen Style Dictionary is the primary method for applying cursor styles to the terminal.
# All Cursor styles are provided from the get go so you don't have to define them yourself!
#
# A Dictionary was chosen to guarentee that the styles are easy to select from.
# You pass a style name, you get the corresponding ansi cursor code.
#

typeset -gA pen=(
    default     $'\e[0 q'
    blinkblock  $'\e[1 q'
    block       $'\e[2 q'
    blinkline   $'\e[3 q'
    line        $'\e[4 q'
    blinkibeam  $'\e[5 q'
    ibeam       $'\e[6 q'
)