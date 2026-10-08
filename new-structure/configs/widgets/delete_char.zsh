function delete_char() {
    if (( REGION_ACTIVE )); then
        zle kill-region
    fi
    zle delete-char
}