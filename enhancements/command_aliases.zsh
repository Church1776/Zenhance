# Clang command aliases
typeset -A llvm_aliases=(
  [lladdr2line]="llvm-addr2line"
  [llar]="llvm-ar"
  [llbolt]="llvm-bolt"
  [llc]="llc"
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
  [mllgoyg]="mlir-linalg-ods-yaml-gen"
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
typeset -A coreutils_aliases=(
  [ls]="ls --color=auto"
  [la]="ls -A --color=auto"
  [ll]="ls -lAh --color=auto"
  [lst]="ls -1 --color=auto"
  [lat]="ls -1A --color=auto"
)
typeset -A custom_shell_aliases=(
)

# Functions to add aliases
function add_shell_aliases {
  local -A r_arr=(${(@Pkv)1})
  local statement="$2"
  #echo "$statement"
  for tool in ${(@k)r_arr}; do
    local toolcmd="${r_arr[$tool]}"
    if (( ! $+commands[${toolcmd%%[[:space:]]*}] )); then
      #printf "${ink[gray]}: %s %s\n" "${ink[gold]}$toolcmd${ink[reset]}" "${ink[beige]}(command not found)${ink[reset]}"
      continue
    fi
    local toolalias="$tool"
    if [[ "$toolalias" == "$toolcmd" ]]; then
      #printf "${ink[gray]}: %s %s\n" "${ink[gold]}$toolcmd${ink[reset]}" "${ink[brighterskyblue]}(no alias needed)${ink[reset]}"
      continue
    fi
    if alias "$toolalias" &>/dev/null; then
      #printf "${ink[gray]}: %s %s\n" "${ink[cerulean]}$toolalias${ink[reset]}" "${ink[brighterskyblue]}(already exists)${ink[reset]}"
      continue
    fi
    alias "$toolalias"="$toolcmd"
    if ! alias "$toolalias" &>/dev/null; then
      #printf "${ink[gray]}: %s %s\n" "${ink[coral]}$toolalias${ink[reset]}" "${ink[beige]}(alias failed)${ink[reset]}"
      continue
    fi
    #printf "${ink[gray]}: %s = '%s'\n" "${ink[forestgreen]}$toolalias${ink[reset]}" "${ink[gold]}$toolcmd${ink[reset]}"
  done
  #echo ""
}
function add_custom_shell_aliases {
  local -A r_arr=(${(@Pkv)1})
  local statement="$2"
  #echo "$statement"
  for tool in ${(@k)r_arr}; do
    local toolalias="$tool"
    local toolcmd="${r_arr[$tool]}"
    if [[ "$toolalias" == "$toolcmd" ]]; then
      #printf "${ink[gray]}: %s %s\n" "${ink[gold]}$toolcmd${ink[reset]}" "${ink[brighterskyblue]}(no alias needed)${ink[reset]}"
      continue
    fi
    if alias "$toolalias" &>/dev/null; then
      #printf "${ink[gray]}: %s %s\n" "${ink[cerulean]}$toolalias${ink[reset]}" "${ink[brighterskyblue]}(already exists)${ink[reset]}"
      continue
    fi
    alias "$toolalias"="$toolcmd"
    if ! alias "$toolalias" &>/dev/null; then
      #printf "${ink[gray]}: %s %s\n" "${ink[coral]}$toolalias${ink[reset]}" "${ink[beige]}(alias failed)${ink[reset]}"
      continue
    fi
    #printf "${ink[gray]}: %s = '%s'\n" "${ink[forestgreen]}$toolalias${ink[reset]}" "${ink[gold]}$toolcmd${ink[reset]}"
  done
  #echo ""
}

# Function to load aliases
function load_shell_aliases {
  add_shell_aliases llvm_aliases "LLVM Toolchain Aliases:"
  add_shell_aliases clang_aliases "Clang Tool Aliases:"
  add_shell_aliases mlir_aliases "MLIR Tool Aliases:"
  add_shell_aliases spirv_aliases "SPIR-V Tool Aliases:"
  add_shell_aliases coreutils_aliases "Core Utility Aliases:"
  add_custom_shell_aliases custom_shell_aliases "Custom Shell Aliases:"
}

load_shell_aliases
