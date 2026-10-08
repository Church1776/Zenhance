function backward_delete_char() {
    if (( REGION_ACTIVE )); then
        zle kill-region
        return
    fi
    local lchar rchar
    case $LBUFFER[-1] in
        '(') lchar='('; rchar=')';;
        '{') lchar='{'; rchar='}';;
        '[') lchar='['; rchar=']';;
        "'") lchar="'"; rchar="'";;
        '"') lchar='"'; rchar='"';;
    esac
    if [[ $lchar == ${LBUFFER[-1]} && $rchar == ${RBUFFER[1]} ]]; then
        LBUFFER=${LBUFFER[1,-2]}
        RBUFFER=${RBUFFER[2,-1]}
        return
    fi
    zle backward-delete-char;
}