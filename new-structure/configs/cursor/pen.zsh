# The Pen Style Dictionary is the primary method for applying cursor styles to the terminal.
# All Cursor styles are provided from the get go so you don't have to define them yourself!
#
# A Dictionary was chosen to guarentee that the styles are easy to select from.
# You pass a style name, you get the corresponding ansi cursor code.

typeset -gA pen=(
    default     $'\e[0 q'
    block-blink  $'\e[1 q'
    block-solid  $'\e[2 q'
    underline-blink   $'\e[3 q'
    underline-solid   $'\e[4 q'
    line-blink  $'\e[5 q'
    line-solid  $'\e[6 q'
)