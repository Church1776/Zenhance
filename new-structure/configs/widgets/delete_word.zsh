function delete_word() {
    if (( REGION_ACTIVE )); then
        zle kill-region
    fi
    zle delete-word
}
