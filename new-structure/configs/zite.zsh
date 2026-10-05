# The Zsh Interactive Toolkit Editor.
#
# % zep [optional] [codes]
#
# The following Show Colors 'shcolors' utility is the primary tool to display the colors codes within the Ink Dictionary.
#
# Utility will output the color of any given ansi 256 code input, or else print all available colors.
# The formatting will default to a table of 8 columns, unless you decide to change it by assigning a value to SHCOLORSCOLUMNS.
# The spacing is determined by the width of the code passed to the utility plus SHCOLORSPADDING or a default padding of 2.

function zite {
  [[ -z ${ZIT_UTILITY} ]] && echo "zite: Must be called from a zit utility."

  local args=("$@")
}