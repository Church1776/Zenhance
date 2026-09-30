# Interpret the CLI options passed to a utility and return the flagcodes, errmsg, & exitcode.
#
# [Not for direct interaction. Will return an error if used from the cli.]
#
# The following CLI Interpreter subprocess only interprets options passed with the format: -o|--option
#

function cli_interpreter {
  [[ -n $ZEP_ACTIVE ]] || { echo "This process can only be called while a Zsh-Enhance-Processor is running."; return;}

  local args=("$@")
  local longopt=0
  local optlist=()
  local options=()

  if [[ -z ${args[@]} ]]; then
    echo "No arguments passed to cli interpreter."
    return
  fi
    for arg in ${args[@]}; do
      [[ $arg == '-'* ]] && options+=("$arg")
    done
  fi
  if [[ -z $options ]]; then
    flagcode='no-opts'
    return
  fi
  for opt in ${options[@]}; do
    if [[ $opt == '--'* ]]; then longopt=1; else longopt=0; fi
    if [[ $longopt -eq 0 ]]; then
      opt="${opt[2,-1]}"
      for (( i=1; i<=${#opt}; ++i )); do
        case "${opt[$i]}" in
          a)flagcode='all'
          h)flagcode='help'
          v)flagcode='version'
        esac
      done
    else
      if [[ "$opt" == *','* ]]; then longopt=2; else longopt=1; fi
      if [[ $longopt -eq 2 ]]; then
        optlist=("${(@s:,:)opt}")
        for (( i=1; i<=${#opt}; ++i )); do
          case ${optlist[$i]} in
            all)flagcode='all'
            help)flagcode='help'
            version)flagcode='version'
          esac
        done
      fi
      case $opt in
      esac
}