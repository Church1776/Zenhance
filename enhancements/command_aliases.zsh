# Clang command aliases
if [[ -z $llvm_aliases ]]; then
  typeset -A llvm_aliases
fi
llvm_aliases+=(
  [lladdr2line]="llvm-addr2line"
  [llar]="llvm-ar"
  [llbolt]="llvm-bolt"
  [llbcanalyzer]="llvm-bcanalyzer"
  [llas]="llvm-as"
  [lldis]="llvm-dis"
  [llmc]="llvm-mc"
  [lld]="ld.lld"
  [llnm]="llvm-nm"
  [llcat]="llvm-cat"
  [llcov]="llvm-cov"
  [llobjdump]="llvm-objdump"
  [llobjcopy]="llvm-objcopy"
  [llranlib]="llvm-ranlib"
  [llstrip]="llvm-strip"
  [llstrings]="llvm-strings"
  [llreadelf]="llvm-readelf"
  [llreadobj]="llvm-readobj"
  [llsize]="llvm-size"
  [llc++filt]="llvm-cxxfilt"
  [llwindres]="llvm-windres"
  [lldwarfdump]="llvm-dwarfdump"
  [llsplit]="llvm-split"
  [llsymbolizer]="llvm-symbolizer"
)
if [[ -z $clang_aliases ]]; then
  typeset -A clang_aliases
fi
clang_aliases+=(
  [clcpp]="clang-cpp"
  [cldoc]="clang-doc"
  [cltidy]="clang-tidy"
  [clformat]="clang-format"
  [clcheck]="clang-check"
  [clmove]="clang-move"
  [clquery]="clang-query"
  [clapply]="clang-apply-replacements"
)
if [[ -z $mlir_aliases ]]; then
  typeset -A mlir_aliases
fi
mlir_aliases+=(
  [mlopt]="mlir-opt"
  [mlpdll]="mlir-pdll"
  [mlirlsp]="mlir-lsp-server"
  [mlquery]="mlir-query"
  [mlreduce]="mlir-reduce"
  [mlrewrite]="mlir-rewrite"
  [mlrunner]="mlir-runner"
  [mltblgen]="mlir-tblgen"
  [mltranslate]="mlir-translate"
)
if [[ -z $spirv_aliases ]]; then
  typeset -A spirv_aliases
fi
spirv_aliases+=(
  [spvas]="spirv-as"
  [spvcfg]="spirv-cfg"
  [spvdiff]="spirv-diff"
  [spvdis]="spirv-dis"
  [spvlesspipe]="spirv-lesspipe"
  [spvlink]="spirv-link"
  [spvlint]="spirv-lint"
  [spvobjdump]="spirv-objdump"
  [spvopt]="spirv-opt"
  [spvval]="spirv-val"
)
if [[ -z $coreutil_aliases ]]; then
  typeset -A coreutil_aliases
fi
coreutil_aliases+=(
  [ls]="ls --color=auto"
  [la]="ls -a --color=auto"
  [ll]="ls -lAh --color=auto"
  [lst]="ls -1 --color=auto"
  [lsta]="ls -1A --color=auto"
)
if [[ -z $builtin_aliases ]]; then
  typeset -A builtin_aliases
fi
builtin_aliases+=(
)
if [[ -z $custom_aliases ]]; then
  typeset -A custom_aliases
fi
custom_aliases+=(
  [premake]="premake5"
)

# Functions to add aliases
function add_utility_aliases {
  local -A r_arr=(${(@Pkv)1})
  for tool in ${(@k)r_arr}; do
    local toolcmd="${r_arr[$tool]}"
    (( $+commands[$toolcmd] )) || (( $+builtins[$toolcmd] )) || (( $+functions[$toolcmd] )) || continue
    local toolalias="$tool"
    [[ "$toolalias" != "$toolcmd" ]] || continue
    [[ -z "$(alias "$toolalias")" ]] || continue
    if ! alias "$toolalias"="$toolcmd" 2>/dev/null; then
      echo "Failed to create alias: $toolalias -> $toolcmd."
    fi
  done
}

# Function to load aliases
function load_shell_aliases {
  add_utility_aliases llvm_aliases
  add_utility_aliases clang_aliases
  add_utility_aliases mlir_aliases
  add_utility_aliases spirv_aliases
  add_utility_aliases coreutil_aliases
  add_utility_aliases builtin_aliases
  add_utility_aliases custom_aliases
}
load_shell_aliases

# Cleanup all values to keep the shell environment clean
unset -f add_utility_aliases
unset -f add_qualifier_aliases
unset -f load_shell_aliases

unset llvm_aliases
unset clang_aliases
unset mlir_aliases
unset spirv_aliases
unset coreutil_aliases
unset builtin_aliases
unset custom_aliases
