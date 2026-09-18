### Define functions for more expressive package validation.
# Pre-package settings
function zprepkgsettings {
  :
}
# Package Loader
function zloadpackage {
  local zname="$1"; shift
  local zdirs=("$@")

  [[ -n $zname ]] || { echo "No package specified."; return 1; }

  for dir in $zdirs; do
    [[ -d $dir ]] || continue
      zscript="$(find $dir -name ${zname:l}.zsh 2>/dev/null | head -n 1)"
    [[ -f $zscript ]] && break
  done

  [[ -f $zscript ]] || { echo "$zname not installed."; return 1; }
  source ${zscript:A}
}
# Post-package settings
function zpostpkgsettings {
  if [[ -n $ZSH_AUTOSUGGEST_STRATEGY ]]; then
    export ZSH_AUTOSUGGEST_STRATEGY=(history)
  fi

  if [[ -n $ZSH_AUTOSUGGEST_IGNORE_WIDGETS ]]; then
    ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(
    backward_char
    forward_char
    backward_word
    forward_word
    delete_char
    delete_word
    )
    export ZSH_AUTOSUGGEST_IGNORE_WIDGETS
  fi
  if [[ -n $ZSH_HIGHLIGHT_STYLES ]]; then
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=256'
  fi
}


### Load package configurations.
# Grab possible script locations.
typeset -a ZPKGDIRS=(
  "/usr/share"
  "/usr/local/share"
  "/Programs"
  "/Programs/Local"
  "$HOME/.config"
  "$HOME/.local"
)
# Place packages to load.
ZPACKAGES=(
  "Zsh-Autosuggestions"
  "Zsh-Syntax-Highlighting"
)

zprepkgsettings
unset -f zprepkgsettings

for pkg in $ZPACKAGES; do
  zloadpackage "$pkg" "${(@)ZPKGDIRS}"
done
unset -f zloadpackage

zpostpkgsettings
unset -f zpostpkgsettings