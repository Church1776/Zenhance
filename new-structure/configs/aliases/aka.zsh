# The AKA Alias Dictionary is the primary method for applying aliases to the terminal.
# The aliases are provided for specific tooling to allow easier usage of verbose tools while keeping them distinct: llar -> llvm-ar
#
# A Dictionary was chosen instead of an array to guarentee that what number you pass to the dictionary
# would directly correspond to the ansi code without the need to do any arithemetic.
# You pass a 0, you get ansi code 0, you pass a 255, you get ansi 255.
#
# Since ANSI 256 codes have the 0 code referring to a color as opposed to resetting the terminal,
# I made a 'reset' option so you can use the Ink Dictionary to also reset the terminal.

typeset -gA aka=(
  # LLVM aliases
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
  [llcxxfilt]="llvm-cxxfilt"
  [llwindres]="llvm-windres"
  [lldwarfdump]="llvm-dwarfdump"
  [llsplit]="llvm-split"
  [llsymbolizer]="llvm-symbolizer"

  # Clang tool aliases
  [clcpp]="clang-cpp"
  [cldoc]="clang-doc"
  [cltidy]="clang-tidy"
  [clformat]="clang-format"
  [clcheck]="clang-check"
  [clmove]="clang-move"
  [clquery]="clang-query"
  [clapply]="clang-apply-replacements"

  # MLIR aliases
  [mlopt]="mlir-opt"
  [mlpdll]="mlir-pdll"
  [mlirlsp]="mlir-lsp-server"
  [mlquery]="mlir-query"
  [mlreduce]="mlir-reduce"
  [mlrewrite]="mlir-rewrite"
  [mlrunner]="mlir-runner"
  [mltblgen]="mlir-tblgen"
  [mltranslate]="mlir-translate"

  # SPIR-V aliases
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

  # CoreUtil aliases
  [ls]="ls --color=auto"
  [la]="ls -ah --color=auto"
  [ll]="ls -lAh --color=auto"
  [lst]="ls -1 --color=auto"
  [lsta]="ls -1A --color=auto"  
)