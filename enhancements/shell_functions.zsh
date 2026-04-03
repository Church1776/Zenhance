function cds {
  [[ -n $WHOME ]] || return
  case $usys in
	Msys) [[ $PWD == /[a-z] || $PWD == /[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
	Linux) [[ $PWD == /mnt/[a-z] || $PWD == /mnt/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
	Darwin) [[ $PWD == /Volumes/[a-z] || $PWD == /Volumes/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
	*BSD) [[ $PWD == /mnt/[a-z] || $PWD == /mnt/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
	DragonFly) [[ $PWD == /mnt/[a-z] || $PWD == /mnt/[a-z]/* ]] && CHOME=$WHOME  ||  CHOME=$HOME;;
  esac
  if [[ $CHOME == $HOME ]]; then
    export CHOME=$WHOME
    cd $CHOME 
  else
    export CHOME=$HOME
    cd $CHOME
  fi
}

function zh_internal_call_validator {
	local context="$1"
	if [[ $context == 'toplevel:shfunc' ]]; then
		echo "This function is not meant to be called directly."
		return 1
	fi
	return 0
}

function zh_create_file {
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return 1

	local file_path="$1"
	local dest_dir="$(dirname "$file_path")"

	[[ -n "$file_path" ]] || return 1
	[[ -n "$dest_dir" && -d "$dest_dir" ]] || mkdir -p "$dest_dir"

	touch "$file_path"
}
function zh_delete_file {
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return 1

	local file_path="$1"

	[[ -n "$file_path" && -f "$file_path" ]] || return 1

	rm -f "$file_path"
}
function zh_write_to_file {
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return 1

	local file_path="$1"
	local content="$2"

	[[ -n "$file_path" && -f "$file_path" ]] || return 1

  echo -ne "$content" > "$file_path"
}
function zh_append_to_file {
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return 1

	local file_path="$1"
	local content="$2"

	[[ -n "$file_path" && -f "$file_path" ]] || return 1
  
  echo -ne "$content" >> "$file_path"
}
function zh_read_file {
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return 1

	local file_path="$1"
	[[ -n "$file_path" && -f "$file_path" ]] || return 1

	cat "$file_path" 2>/dev/null
}
function zh_text_tab_replacer {	
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return 1

	local text="$1"
	local fmt="${2:-4}"
	local spaces=""

	[[ -n "$text" ]] || return 1
	[[ "$fmt" =~ ^[[:digit:]]+$ ]] || return 1

	for ((i=0; i<fmt; i++)); do
		spaces+=" "
	done

	echo "${text//'\t'/$spaces}"
}
function zh_git_repo_get_root {
	zh_internal_call_validator "$ZSH_EVAL_CONTEXT" || return ''
	
	local repo_path="$(git rev-parse --show-toplevel 2>/dev/null)"
	
	[[ -n "$repo_path" && -d "$repo_path/.git" ]] || return ''

	echo "$repo_path"
}

function mkheader {
	local file_name="$1"
	local file_path="${2:-${file_name:h}}"
	local header_content="${3:-}"
	local ext="${file_name:e}"
	local idir=''
	local file=''
  local type=''
	local guard=''

  file_name="${file_name:t}"

  if [[ "$file_path" == '.' ]]; then    # Only use actual file paths, not relative placeholders like '.' or '..'
    file_path="$PWD"
  fi
	
	idir="$(echo $PWD | sed -E "s|(.*include\|.*incl\|.*inc).*|\1|g")"
	file_path="${file_path#$idir}"
  file_path="${file_path#/}"
  file_path="${file_path%/}"
  echo "Include Directory: $idir${file_path:+/$file_path}"

	file="$idir${file_path:+/$file_path}/${file_name:r}.${ext:-h}"
	
	echo "Header File: ${file:t}"
	echo "Header Directory: ${file:h}"
	
	guard="${file#*$idir/}"
	guard="${guard//\//_}"
	guard="${guard//./_}"
	guard="${guard:u}"

	echo "Header guard:\n#ifndef $guard\n#define $guard\n\n$header_content\n\n#endif//$guard"
  zh_create_file "$file"
  zh_write_to_file "$file" "#ifndef $guard\n#define $guard\n\n"
  zh_append_to_file "$file" "$header_content\n\n"
  zh_append_to_file "$file" "#endif//$guard"
}

function mksource { #TODO: Refactor this function to be more robust and handle edge cases better
	local file_name="$1"
	local file_path="${2:-${file_name:h}}"
	local ext="${file_name:e}"
	local sdir=''
  local idir=''
	local file=''
	local header_file=''
	local include=''
	
  file_name="${file_name:t}"          # Only use actual file paths, not relative placeholders like '.' or '..'
  if [[ "$file_path" == '.' ]]; then
    file_path="$PWD"
  fi

	sdir="$(echo $PWD | sed -E "s|(.*source\|.*srce\|.*src\|.*library\|.*libs\|.*lib).*|\1|g")"
  file_path="${file_path#$sdir}"
  file_path="${file_path#/}"
  file_path="${file_path%/}"
	file="$sdir${file_path:+/$file_path}/${file_name:r}.${ext:-cpp}"
	echo "Source File: ${file}"

  idir="$(find ${sdir%/[ls]*[ir][bc]*} -maxdepth 1 -type d -name "inc"* 2>/dev/null | head -n 1)"
	if [[ $sdir != */[ls]*[ir][bc]* && -n "$idir" ]]; then
		idir="${idir%/inc*}"
	fi
	file_path="${file:h}"
	file_path="${file_path#$sdir}"
  file_path="${file_path#/}"
  file_path="${file_path%/}"
  echo "Include Dir: ${idir}${file_path:+/$file_path}"

	echo "Source Header search command: find ${idir}${file_path:+/$file_path} -maxdepth 1 -type f -name \"${file:t:r}.h*\" 2>/dev/null | head -n 1"
	headerfile="$(find "${idir:-.}${file_path:+/$file_path}" -maxdepth 1 -type f -name "${file:t:r}.h*" 2>/dev/null | head -n 1)"
  
  echo "Related Header: ${headerfile#*$idir/}"

	include="${headerfile#*$idir/}"
	echo "Include Statement:\n${include:+"#include \"$include\""}"

  zh_create_file "$file"
  [[ -n "$include" ]] && zh_write_to_file "$file" "${include:+"#include \"$include\""}"
}

function mkmodule {
	local mod_name="$1"
	local mod_path="${2:-${mod_name:h}}"
	local ext_impl="${mod_name:e}"
	local ext_int="${mod_name:e}"
  local repo_root=''
  local idir=''
  local sdir=''
	local mod_impl=''
	local mod_int=''
	
  mod_name="${mod_name:t}"
	ext_int="${ext_int//c/h}"
	ext_impl="${ext_impl//h/c}"

	if [[ $ext_impl != 'cpp' && $ext_impl != 'cxx' && $ext_impl != 'cc' && $ext_impl != 'c' ]]; then
		ext_impl='cpp'
	fi
	if [[ $ext_int != 'hpp' && $ext_int != 'hxx' && $ext_int != 'hh' && $ext_int != 'h' ]]; then
		ext_int='h'
	fi

  if [[ "$mod_path" == '.' ]]; then
    mod_path="$PWD"
  fi
	
  repo_root="$PWD"
  if [[ $repo_root == *'/inc'* ]]; then
		repo_root="${repo_root%%/inc*}"
  elif [[ $repo_root == *'/s'*'rc'* ]]; then
    repo_root="${repo_root%%/s*rc*}"
  elif [[ $repo_root == *'/lib'* ]]; then
    repo_root="${repo_root%%/lib*}"    
  fi
	
  idir="$(find "$repo_root" -maxdepth 1 -type d -name inc* 2>/dev/null | head -n 1)"
	idir="${idir#*$repo_root}"
	idir="${idir#/}"
	idir="${idir%/}"
  sdir="$(find "$repo_root" -maxdepth 1 -type d -name [ls]*[ir][bc]* 2>/dev/null | head -n 1)"
	sdir="${sdir#*$repo_root}"
	sdir="${sdir#/}"
	sdir="${sdir%/}"
	
  echo "Repository root: $repo_root"
  echo "Include directory: $repo_root${idir:+/$idir}"
  echo "Source directory: $repo_root${sdir:+/$sdir}"

	echo "Creating C++ module: $mod_name"
  mod_path="${mod_path#*$repo_root}"
  mod_path="${mod_path#*$idir}"
  mod_path="${mod_path#*$sdir}"
  mod_path="${mod_path#/}"
  mod_path="${mod_path%/}"
  echo "Module path: $mod_path"
	
	mod_int="${repo_root:+$repo_root/}${idir:+$idir/}${mod_path:+$mod_path/}${mod_name:r}.$ext_int"
	mod_impl="${repo_root:+$repo_root/}${sdir:+$sdir/}${mod_path:+$mod_path/}${mod_name:r}.$ext_impl"
	echo -e "\nModule interface file: $mod_int"
	if [[ ! -d ${mod_int:h} ]]; then
		mkdir -p "${mod_int:h}"
	fi
	cd ${mod_int:h}
	mkheader "${mod_int:t}" "${mod_int:h}"
	cd - 1>/dev/null
	echo -e "\nModule implementation: $mod_impl"
	if [[ ! -d ${mod_impl:h} ]]; then
		mkdir -p "${mod_impl:h}"
	fi
	cd ${mod_impl:h}
	mksource "${mod_impl:t}" "${mod_impl:h}"
	cd - 1>/dev/null
}
function mktest {
	local origin_source="$1"
	local origin_header="$2"
	local test_source=''
	local test_header=''
	local source_content=''
	local header_content=''
}
function mkclass {
	local class_name="$1"
	local class_path="${2:-${class_name:h}}"
	local ext="${class_name:e}"
	local idir=''
	local sdir=''
	local repo_root=''
	local class_header_file=''
	local class_source_file=''
	
	class_name="${class_name:t}"
	if [[ "$class_path" == '.' ]]; then
		class_path="$PWD"
	fi
	  repo_root="$PWD"

  if [[ $repo_root == *'/inc'* ]]; then
    repo_root="${repo_root%%/inc*}"
  elif [[ $repo_root == *'/s'*'rc'* ]]; then
    repo_root="${repo_root%%/s*rc*}"
  elif [[ $repo_root == *'/lib'* ]]; then
    repo_root="${repo_root%%/lib*}"    
  fi
	
  idir="$(find "$repo_root" -maxdepth 1 -type d -name inc* 2>/dev/null | head -n 1)"
	idir="${idir#$repo_root}"
	idir="${idir#/}"
	idir="${idir%/}"
  sdir="$(find "$repo_root" -maxdepth 1 -type d -name [ls]*[ir][bc]* 2>/dev/null | head -n 1)"
	sdir="${sdir#$repo_root}"
	sdir="${sdir#/}"
	sdir="${sdir%/}"
	class_path="${class_path#*$repo_root}"
	class_path="${class_path#*$idir}"
	class_path="${class_path#*$sdir}"
	class_path="${class_path#/}"
	class_path="${class_path%/}"
	
	class_header_file="$idir${class_path:+/$class_path}/${class_name:r}.${ext:-h}"
	class_source_file="$sdir${class_path:+/$class_path}/${class_name:r}.${ext:-cpp}"
	echo "Creating Class: $class_name"
	echo "Class header file: $class_header_file"
	echo "Class source file: $class_source_file"
}