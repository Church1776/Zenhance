function select_forward_word() {
    if (( ! REGION_ACTIVE )); then
        zle set-mark-command
    fi
    zle forward-word
}