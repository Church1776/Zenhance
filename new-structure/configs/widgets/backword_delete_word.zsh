function backward_delete_word() {
    if (( REGION_ACTIVE )); then
        zle kill-region
        return
    fi
    zle backward-delete-word
}