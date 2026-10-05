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
  
  # Coreutil aliases
  [ls]="ls -A --color=auto"
  [la]="ls -a --color=auto"
  [ll]="ls -lah --color=auto"
  [li]="ls -1A --color=auto"
  
  # LLVM aliases
  [lla2l]='llvm-addr2line.exe'
  [llar]='llvm-ar.exe'
  [llas]='llvm-as.exe'
  [llbcanalyzer]='llvm-bcanalyzer.exe'
  [llbcstrip]='llvm-bitcode-strip.exe'
  [llcas]='llvm-cas.exe'
  [llcat]='llvm-cat.exe'
  [llcgdata]='llvm-cgdata.exe'
  [llconfig]='llvm-config.exe'
  [llcov]='llvm-cov.exe'
  [llctxprof-util]='llvm-ctxprof-util.exe'
  [llcvtres]='llvm-cvtres.exe'
  [llcxxdump]='llvm-cxxdump.exe'
  [llcxxfilt]='llvm-cxxfilt.exe'
  [llcxxmap]='llvm-cxxmap.exe'
  [lld]='ld.lld'
  [lldiff]='llvm-diff.exe'
  [lldis]='llvm-dis.exe'
  [lldlltool]='llvm-dlltool.exe'
  [lldwarfdump]='llvm-dwarfdump.exe'
  [lldwarfutil]='llvm-dwarfutil.exe'
  [lldwp]='llvm-dwp.exe'
  [llexegesis]='llvm-exegesis.exe'
  [llextract]='llvm-extract.exe'
  [llgsymutil]='llvm-gsymutil.exe'
  [llifs]='llvm-ifs.exe'
  [llinstall-name-tool]='llvm-install-name-tool.exe'
  [llir2vec]='llvm-ir2vec.exe'
  [lljlink]='llvm-jitlink.exe'
  [lljlink-executor]='llvm-jitlink-executor.exe'
  [llib]='llvm-lib.exe'
  [llibdarwin]='llvm-libtool-darwin.exe'
  [llink]='llvm-link.exe'
  [llipo]='llvm-lipo.exe'
  [llto]='llvm-lto.exe'
  [llto2]='llvm-lto2.exe'
  [llmc]='llvm-mc.exe'
  [llmca]='llvm-mca.exe'
  [llml]='llvm-ml.exe'
  [llml64]='llvm-ml64.exe'
  [llmodextract]='llvm-modextract.exe'
  [llmt]='llvm-mt.exe'
  [llnm]='llvm-nm.exe'
  [llobjcopy]='llvm-objcopy.exe'
  [llobjdump]='llvm-objdump.exe'
  [llolb]='llvm-offload-binary.exe'
  [llolw]='llvm-offload-wrapper.exe'
  [llopt-report]='llvm-opt-report.exe'
  [llotool]='llvm-otool.exe'
  [llpdbutil]='llvm-pdbutil.exe'
  [llPerfectShuffle]='llvm-PerfectShuffle.exe'
  [llprofdata]='llvm-profdata.exe'
  [llprofgen]='llvm-profgen.exe'
  [llranlib]='llvm-ranlib.exe'
  [llrc]='llvm-rc.exe'
  [llreadelf]='llvm-readelf.exe'
  [llreadobj]='llvm-readobj.exe'
  [llreadtapi]='llvm-readtapi.exe'
  [llreduce]='llvm-reduce.exe'
  [llremarkutil]='llvm-remarkutil.exe'
  [llrtdyld]='llvm-rtdyld.exe'
  [llsim]='llvm-sim.exe'
  [llsize]='llvm-size.exe'
  [llsplit]='llvm-split.exe'
  [llstress]='llvm-stress.exe'
  [llstrings]='llvm-strings.exe'
  [llstrip]='llvm-strip.exe'
  [llsymbolizer]='llvm-symbolizer.exe'
  [lltblgen]='llvm-tblgen.exe'
  [lltest-mustache-spec]='llvm-test-mustache-spec.exe'
  [lltli-checker]='llvm-tli-checker.exe'
  [llundname]='llvm-undname.exe'
  [llwindres]='llvm-windres.exe'
  [llxray]='llvm-xray.exe'

  # Clang tool aliases
  [clcpp]="clang-cpp"
  [cldoc]="clang-doc"
  [cltidy]="clang-tidy"
  [clformat]="clang-format"
  [clcheck]="clang-check"
  [clmove]="clang-move"
  [clquery]="clang-query"
  [clapply-replacements]="clang-apply-replacements"

  # MLIR aliases
  [mlopt]='mlir-opt'
  [mlpdll]='mlir-pdll'
  [mlirlsp]='mlir-lsp-server'
  [mlquery]='mlir-query'
  [mlreduce]='mlir-reduce'
  [mlrewrite]='mlir-rewrite'
  [mlrunner]='mlir-runner'
  [mltblgen]='mlir-tblgen'
  [mltranslate]='mlir-translate'

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
)