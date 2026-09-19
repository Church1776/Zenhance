### Define functions for more expressive package validation.

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


for pkg in $ZPACKAGES; do
  zloadpackage "$pkg" "${(@)ZPKGDIRS}"
done
unset -f zloadpackage
