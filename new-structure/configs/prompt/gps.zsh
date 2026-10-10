# The Prompt Global Position System is the primary method for storing prompt color codes in the terminal.
# All gps styles are provided from the get go so you don't have to define them yourself!
#
# A Dictionary was chosen to guarentee that the styles are easy to select from.
# You pass a style name, you get the corresponding ansi color code.

typeset -gA gps=(
    [name]=${gps[name]:-'208'}
    [at]=${gps[at]:-'214'}
    [machine]=${gps[machine]:-'228'}
    [system]=${gps[system]:-'62'}
    [unixpath]=${gps[unixpath]:-'35'}
    [unixZ]=${gps[unixZ]:-'121'}
    [winpath]=${gps[winpath]:-'33'}
    [winZ]=${gps[winZ]:-'51'}
    [vcs]=${gps[vcs]:-'245'}
    [vcs2]=${gps[vcs2]:-'250'}
    [vcs3]=${gps[vcs3]:-'reset'}
    [colon]=${gps[colon]:-'245'}
)

if [[ -f "$ZIT_CACHE/prompt.zsh" ]]; then
  while IFS= read -r line; do
    line=${${line//*'['/}//']'*/}
    if [[ ${(k)gps[*]} != *" $line "* ]]; then
      rm "$ZIT_CACHE/prompt.zsh"
      break
    fi
  done < "$ZIT_CACHE/prompt.zsh"
fi
unset line

if [[ ! -f "$ZIT_CACHE/prompt.zsh" ]]; then
  for key in ${(k)gps}; do
    echo "gps[$key]='${gps[$key]}'" >> "$ZIT_CACHE/prompt.zsh"
  done
fi
unset key