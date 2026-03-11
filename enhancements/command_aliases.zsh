# Clang command aliases
typeset -A llvm_aliases=(
  [lladdr2line]="llvm-addr2line"
  [llar]="llvm-ar"
  [llbolt]="llvm-bolt"
  [llbc]="llvm-bcanalyzer"
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
)
typeset -A clang_aliases=(
  [clcpp]="clang-cpp"
  [cldoc]="clang-doc"
  [cltidy]="clang-tidy"
  [clformat]="clang-format"
  [clcheck]="clang-check"
  [clmove]="clang-move"
  [clquery]="clang-query"
  [clapply]="clang-apply-replacements"
)
typeset -A mlir_aliases=(
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
typeset -A spirv_aliases=(
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
typeset -A coreutil_aliases=(
  [ls]="ls --color=auto"
  [la]="ls -A --color=auto"
  [ll]="ls -lAh --color=auto"
  [lst]="ls -1 --color=auto"
  [lsta]="ls -1A --color=auto"
)
typeset -A builtin_aliases=(
  [cdwh]="cd $WHOME"
  [cduh]="cd $UHOME"
)
typeset -A custom_aliases=(
)

# Functions to add aliases
function add_utility_aliases {
  local -A r_arr=(${(@Pkv)1})
  local statement="$2"
  for tool in ${(@k)r_arr}; do
    local toolcmd="${r_arr[$tool]}"
    (( $+commands[$toolcmd] )) || continue
    local toolalias="$tool"
    [[ "$toolalias" != "$toolcmd" ]] || continue
    [[ -z "$(alias "$toolalias")" ]] || continue
    alias "$toolalias"="$toolcmd"
    if ! alias "$toolalias" &>/dev/null; then
      continue
    fi
  done
}

function add_qualifier_aliases {
  local -A r_arr=(${(@Pkv)1})
  local statement="$2"
  for tool in ${(@k)r_arr}; do
    local toolcmd="${r_arr[$tool]}"
    local toolalias="$tool"
    [[ "$toolalias" != "$toolcmd" ]] || continue
    if alias "$toolalias" &>/dev/null; then
      continue
    fi
    alias "$toolalias"="$toolcmd"
    if ! alias "$toolalias" &>/dev/null; then
      continue
    fi
  done
}

# Function to load aliases
function load_shell_aliases {
  add_utility_aliases llvm_aliases "LLVM Toolchain Aliases:"
  add_utility_aliases clang_aliases "Clang Tool Aliases:"
  add_utility_aliases mlir_aliases "MLIR Tool Aliases:"
  add_utility_aliases spirv_aliases "SPIR-V Tool Aliases:"
  add_qualifier_aliases coreutil_aliases "Core Utility Aliases:"
  add_qualifier_aliases builtin_aliases "Builtin Shell Aliases:"
  add_qualifier_aliases custom_aliases "Custom Shell Aliases:"
}
load_shell_aliases
