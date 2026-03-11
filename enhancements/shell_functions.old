function __check_git_repo_status {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Error: Not inside a git repository."
        return 1
    fi
    return 0
}
function __fetch_git_top_level {
    if ! __check_git_repo_status; then
        return 1
    fi
    git rev-parse --show-toplevel 2>/dev/null
}
function __argument_assignment_checker {
    if [[ -z "$1" ]]; then
        return 1
    fi
    return 0
}
function __filename_resolver {
    if [[ ! -e "$1" ]]; then
        echo "$1"
        return
    else
        name_extension="${1##*.}"
        name_base="${1%.*}"
        new_name="${name_base}_0.${name_extension}"
        name_valid=false
        while [[ ! $name_valid ]]; do
            if [[ ! -e "$new_name" ]]; then
                name_valid=true
                break
            fi
            new_name="${name_base}_$(( ${new_name##*_} + 1 )).${name_extension}"
        done
        echo "$new_name"
    fi
}


function _mksrc {
    source_name="$1"
    dest_dir="$2"
    related_header="$3"
            
    __argument_assignment_checker "$source_name" || source_name="unnamed_source.cpp"
    
    __argument_assignment_checker "$dest_dir" || dest_dir="."
    
    __argument_assignment_checker "$related_header" || related_header=''
    
    #echo "Source name: $source_name"
    #echo "Destination directory: $dest_dir"
    #echo "Related Header: $related_header"
    
    src_x="${source_name##*.}"
    if [[ -n $src_x && "$src_x" != "c" && "$src_x" != "cpp" && "$src_x" != "cc" && "$src_x" != "cxx" ]]; then
        src_x="cpp"
        source_name="${source_name%.*}.$src_x"
    fi
    
    source_file_name="$source_name"
    source_file_name=$( __filename_resolver "$source_file_name" )
    
    source_full_name="$dest_dir/$source_file_name"
    
    #echo "Source resolved name: $source_file_name"
    #echo "Source full name: $source_full_name"
    
    mkdir -p "$dest_dir"
    touch "$source_full_name"
    
    if [[ -n "$related_header" ]]; then
        if [[ $related_header == /* ]]; then
            echo "Related header is an absolute path. Converting to relative path."
            related_header="${related_header#/}"
        fi
        if [[ $related_header == *inc* ]]; then
            echo "Stripped path from parent up to '*inc/'."
            echo "Clangd is formatted to the project include directories. (engine/inc, game/inc)"
            related_header="${related_header##*inc/}"
        fi
        echo "#include \"$related_header\"" > "$source_full_name"
        echo "" >> "$source_full_name"
    fi
    echo "// Your implementations go here!" >> "$source_full_name" 
    
    echo "Created source file at:"
    echo "$source_full_name"   
}
function _mkhdr {
    local header_name="$1"
    local dest_dir="$2"
    local type_qualifier="$3"
    local scope_qualifier="$4"
    local git_repo_toplevel=""
    local temp_git=""
    
    temp_git="$(__fetch_git_top_level)" && git_repo_ toplevel="$temp_git"
    
    echo "Git repository top-level directory: $git_repo_toplevel"
    __argument_assignment_checker "$header_name" || header_name="unnamed_$type_qualifier.h"
    
    __argument_assignment_checker "$dest_dir" || dest_dir="."
    
    __argument_assignment_checker "$type_qualifier" || type_qualifier="header"
    
    __argument_assignment_checker "$scope_qualifier" || scope_qualifier=""
    
    hdr_x="${header_name##*.}"
    
    if [[ -n $hdr_x && "$hdr_x" != "h" && "$hdr_x" != "hh" && "$hdr_x" != "hxx" && "$hdr_x" != "hpp" ]]; then
        hdr_x="h"
        header_name="${header_name%.*}.$hdr_x"
    fi
    
    
        
    echo "Initial Header name: $header_name"
    echo "Final Destination directory: $dest_dir"
    echo "Type qualifier: $type_qualifier"
    echo "Scope qualifier: $scope_qualifier"

    header_file_name="$header_name"
    header_file_name="$(__filename_resolver "$header_file_name")"
    header_full_name="${dest_dir}${header_file_name}"
    header_full_dir="$(dirname "$header_full_name")"
    header_name="${header_file_name%.*}"
    #echo "Header full name: $header_full_name"
    #echo "Header resolved name: $header_file_name"
    echo "Creating header file at: $header_full_name"
    echo "Header full directory: $header_full_dir"
    echo "Header name: $header_name"
    if [[ -n $header_full_dir && ! -d $header_full_dir ]]; then
        mkdir -p "$header_full_dir"
    fi
    touch "$header_full_name"

    spaces=""
    if [[ -n "$scope_qualifier" ]]; then
        spaces="    "
    fi
    header_guard_name="${(U)header_full_name##*inc/}"
    header_guard_name="${header_guard_name##*./}"
    header_guard_name="${header_guard_name//./_}"
    header_guard_name="${header_guard_name//\//_}"
    
    echo "Header guard name: $header_guard_name"
    return
    echo "#ifndef ${(U)header_guard_name}" >> "$header_full_name"
    echo "#define ${(U)header_guard_name}" >> "$header_full_name"
    echo "" >> "$header_full_name"
    echo "// Your declarations go here!" >> "$header_full_name"
    echo "" >> "$header_full_name"
    if [[ -n "$scope_qualifier" ]]; then
        echo "namespace $scope_qualifier {" >> "$header_full_name"
        echo "    " >> "$header_full_name"
        echo "    // Namespace symbols here." >> "$header_full_name"
        echo "    " >> "$header_full_name"
    fi
    if [[ "$type_qualifier" =~ ^('enum'|'union')$ ]]; then
        echo "${spaces}${type_qualifier} $header_name {" >> "$header_full_name"
        echo "${spaces}    // Members here." >> "$header_full_name"
        echo "${spaces}};" >> "$header_full_name"
        echo "${spaces}" >> "$header_full_name"
    elif [[ "$type_qualifier" == "template" ]]; then
        echo "${spaces}template <typename T>" >> "$header_full_name"
        echo "${spaces}class $header_name {" >> "$header_full_name"
        echo "${spaces}public:" >> "$header_full_name"
        echo "${spaces}    $header_name();" >> "$header_full_name"
        echo "${spaces}    ~$header_name();" >> "$header_full_name"
        echo "${spaces}    // Public Members Here" >> "$header_full_name"
        echo "${spaces}protected:" >> "$header_full_name"
        echo "${spaces}    // Protected Members Here" >> "$header_full_name"
        echo "${spaces}private:" >> "$header_full_name"
        echo "${spaces}    // Private Members Here" >> "$header_full_name"
        echo "${spaces}};" >> "$header_full_name"
        echo "${spaces}" >> "$header_full_name"
    elif [[ "$type_qualifier" =~ ^('class'|'struct')$ ]]; then
        echo "${spaces}${type_qualifier} $header_name {" >> "$header_full_name"
        echo "${spaces}public:" >> "$header_full_name"
        echo "${spaces}    $header_name();" >> "$header_full_name"
        echo "${spaces}    ~$header_name();" >> "$header_full_name"
        echo "${spaces}    // Public Members Here" >> "$header_full_name"
        echo "${spaces}protected:" >> "$header_full_name"
        echo "${spaces}    // Protected Members Here" >> "$header_full_name"
        echo "${spaces}private:" >> "$header_full_name"
        echo "${spaces}    // Private Members Here" >> "$header_full_name"
        echo "${spaces}};" >> "$header_full_name"
        echo "${spaces}" >> "$header_full_name"
    fi
    if [[ -n "$scope_qualifier" ]]; then
        echo "} // namespace $scope_qualifier" >> "$header_full_name"
        echo "" >> "$header_full_name"
    fi
    echo "#endif // ${(U)header_guard_name}" >> "$header_full_name"
    
    echo "$header_full_name"
}

function mksource {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mksource [source_name] [destination_directory] [related_header_file]"
        echo "Creates a source file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_source' will be used."
        echo "If no directory is provided, the default is '<current_directory>/src'."
        echo "If no related header is provided, no #include directive will be added."
        return
    fi
    _mksrc "$1" "$2" "$3"
}
function mkheader {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ || "$4" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mkheader [header_name] [destination_directory] [optional_type_qualifier] [optional_scope_qualifier]"
        echo "Creates a header file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_header' will be used."
        echo "If no directory is provided, the default is '<current_directory>/inc'."
        echo "If no scope is provided, header will be global."
        return
    fi
    _mkhdr "$1" "$2" "$3" "$4"
}
function mkclass {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ || "$4" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mkclass [class_name] [destination_directory] [optional_scope_qualifier]"
        echo "Creates a class header file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_class' will be used."
        echo "If no directory is provided, the default is '<current_directory>/inc'."
        echo "Option for adding scoped namespace to the header file."
        return
    fi
    
    header_file_path="$(_mkhdr "$1" "${2//src/inc}" 'class' "$3")"
    echo "Header created at: $header_file_path"
    source_file_name="$(basename ${header_file_path%.*}.cpp)"
    echo "Source file to be created: $source_file_name"
    source_dest_dir="$(dirname "${header_file_path//inc/src/}")"
    echo "Source file destination directory: $source_dest_dir"
    _mksrc "$source_file_name" "$source_dest_dir" "${header_file_path##*../}"
}
function mkstruct {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ || "$4" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mkstruct [struct_name] [destination_directory] [optional_scope_qualifier]"
        echo "Creates a struct header file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_struct' will be used."
        echo "If no directory is provided, the default is '<current_directory>/inc'."
        echo "Option for adding scoped namespace to the header file."
        return
    fi
    _mkhdr "$1" "$2" 'struct' "$3"
}
function mkenum {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ || "$4" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mkenum [enum_name] [destination_directory] [optional_scope_qualifier]"
        echo "Creates an enum header file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_enum' will be used."
        echo "If no directory is provided, the default is '<current_directory>/inc'."
        echo "Option for adding scoped namespace to the header file."
        return
    fi
    _mkhdr "$1" "$2" 'enum' "$3"
}
function mkunion {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ || "$4" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mkunion [union_name] [destination_directory] [optional_scope_qualifier]"
        echo "Creates a union header file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_union' will be used."
        echo "If no directory is provided, the default is '<current_directory>/inc'."
        echo "Option for adding scoped namespace to the header file."
        return
    fi
    _mkhdr "$1" "$2" 'union' "$3"
}
function mktemplate {
    if [[ "$1" =~ ^('-h'|'--help')$ || "$2" =~ ^('-h'|'--help')$ || "$3" =~ ^('-h'|'--help')$ || "$4" =~ ^('-h'|'--help')$ ]]; then
        echo "Usage: mktemplate [template_name] [destination_directory] [optional_scope_qualifier]"
        echo "Creates a template header file with the specified name in the given directory."
        echo "If no name is provided, 'unnamed_template' will be used."
        echo "If no directory is provided, the default is '<current_directory>/inc'."
        echo "Option for adding scoped namespace to the header file."
        return
    fi
    _mkhdr "$1" "$2" 'template' "$3"
}