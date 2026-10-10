

typeset -gA dict=(
  ['\e[1;5A']='up-line-or-history'
  ['\eO1;5A']='up-line-or-history'
  ['\e[1;5B']='down-line-or-history'
  ['\eO1;5B']='down-line-or-history'
  ['\e[5~']='beginning-of-history'
  ['\eO5~']='beginning-of-history'
  ['\e[6~']='end-of-history'
  ['\eO6~']='end-of-history'
  ['\e[H']='beginning-of-line'
  ['\eOH']='beginning-of-line'
  ['\e[F']='end-of-line'
  ['\eOF']='end-of-line'
  ['\e[1;6Z']='redo'
  ['\eO1;6Z']='redo'
  ['^_']='redo'
  ['^X']='describe-key-briefly'
  ['^Z']='undo'
  ['\e[C']='forward_char'
  ['\eOC']='forward_char'
  ['\e[1;2C']='select_forward_char'
  ['\eO1;2C']='select_forward_char'
  ['\e[D']='backward_char'
  ['\eOD']='backward_char'
  ['\e[1;6D']='select_backward_word'
  ['\eO1;6D']='select_backward_word'
  ['\e[1;5C']='forward_word'
  ['\eO1;5C']='forward_word'
  ['\e[1;6C']='select_forward_word'
  ['\eO1;6C']='select_forward_word'
  ['\e[1;5D']='backward_word'
  ['\eO1;5D']='backward_word'
  ['\e[1;2D']='select_backward_char'
  ['\eO1;2D']='select_backward_char'  
  ['\e[2~']='overwrite_mode'
  ['\e[3~']='delete_char'
  ['\eO3~']='delete_char'
  ['\e[3;5~']='delete_word'
  ['\eO3;5~']='delete_word'
  ['^?']='backward_delete_char'
  ['^W']='backward_delete_word'
  ['^H']='backward_delete_word'
  ['\e[Z']='interactive_cd'
  ['\eOZ']='interactive_cd'
  ["'"]='single_quote'
  ['"']='double_quote'
  ['(']='open_parens'
  ['[']='open_brackets'
  ['{']='open_braces'
  [')']='close_parens'
  [']']='close_brackets'
  ['}']='close_braces'
)

for value in "${(@v)dict}"; do
    if (( ! $+widgets[$value] )); then
        zle -N $value
    fi
done

for key in "${(@k)dict}"; do
    tmpk="$(bindkey "$key")"
    tmpk="${tmpk##*\" }"
    if [[ "$tmpk" != "undefined-key" ]]; then
        continue
    fi
    bindkey "$key" "${dict[$key]}"
done