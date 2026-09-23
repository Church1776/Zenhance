#List of functions to create custom zle widgets and bind keys to them.
function declare_custom_widgets {
  overwrite_mode() { zle overwrite-mode; [[ $ZLE_STATE == *"overwrite"* ]] && { echo -ne '\e[1 q\e[?12h'; return; }; echo -ne '\e[3 q\e[?12h'; }
  
interactive_cd() {
  local root="$PWD"
  local level=0
  local display=""
  local response action chosen query
  local -a response_lines
  local fzf_cmd=${FZF_BASE:-fzf}

  [[ $LBUFFER == cd || $LBUFFER == 'cd '* ]] || {
    zle .expand-or-complete
    return
  }

  query=${LBUFFER#cd }
  zle -I

  while true; do
    if ! response=$(
      {
        print -r -- .
        fd --type d --hidden --follow --max-depth 1
      } |
        "$fzf_cmd" \
          --height=40% \
          --layout=reverse \
          --scheme=path \
          --prompt="${level}: ${display}> " \
          --query="${query}" \
          +m \
          --bind='enter:become(printf "accept\n%s\n" {})' \
          --bind='right:become(printf "descend\n%s\n" {})' \
          --bind='left:become(printf parent)'
    ); then
      zle reset-prompt
      return
    fi

    response_lines=("${(@f)response}")
    action=${response_lines[1]}
    chosen=${response_lines[2]}

    case $action in
      descend)
        cd -- "$chosen" 2>/dev/null || continue
        root="$PWD"
        (( --level ))
        if (( $level > 0 )); then
          display="${display%/*}"
          display="${display%/*}"
          display="${display:+$display/}"
        elif (( $level == 0 )); then
          display=''
        else
          display+="$chosen"
        fi
        ;;
      parent)
        if [[ ! $root == / ]]; then
          cd -- ".." 2>/dev/null || continue
          root="$PWD"
          (( ++level ))
          if (( $level < 0 )); then
            display="${display%/*}"
            display="${display%/*}"
            display="${display:+$display/}"
          elif (( $level == 0 )); then
            display=''
          else
            display+='../'
          fi
        fi
        ;;
      accept)
        [[ $chosen == . ]] && chosen=$root
        [[ -n $chosen && -d $chosen ]] || return

        cd -- "$chosen" || return
        BUFFER=
        CURSOR=0
        precmd
        zle reset-prompt
        return
        ;;
    esac

    query=
  done
}

  backward_char() {(( REGION_ACTIVE )) && {(( CURSOR > MARK )) && { CURSOR=$MARK;}; zle deactivate-region; return;}; zle backward-char;}
  select_backward_char() {(( REGION_ACTIVE )) || zle set-mark-command; zle backward-char;}

  forward_char() {(( REGION_ACTIVE )) && {(( CURSOR < MARK )) && { CURSOR=$MARK;}; zle deactivate-region; return;}; zle forward-char;}
  select_forward_char() {(( REGION_ACTIVE )) || zle set-mark-command; zle forward-char;}

  backward_word() {(( REGION_ACTIVE )) && {(( CURSOR > MARK )) && { CURSOR=$MARK;}; zle deactivate-region; return;}; zle backward-word;}
  select_backward_word() {(( REGION_ACTIVE )) || zle set-mark-command; zle backward-word;}

  forward_word() {(( REGION_ACTIVE )) && {(( CURSOR < MARK )) && { CURSOR=$MARK;}; zle deactivate-region; return;}; zle forward-word;}
  select_forward_word() {(( REGION_ACTIVE )) || zle set-mark-command; zle forward-word;}

  delete_char() {(( REGION_ACTIVE )) && zle kill-region; zle delete-char;}
  delete_word() {(( REGION_ACTIVE )) && zle kill-region; zle delete-word;}

  backward_delete_char() {(( REGION_ACTIVE )) && { zle kill-region; return; }; zle backward-delete-char;}
  backward_delete_word() {(( REGION_ACTIVE )) && { zle kill-region; return; }; zle backward-delete-word;}

  wrap_region() {
    local open="$1"
    local close="$2"
    (( REGION_ACTIVE )) || { zle self-insert; return; }
    (( MARK > CURSOR )) && { local -i ORIG=CURSOR; CURSOR=$MARK; MARK=$ORIG; }
    local text=${BUFFER[MARK+1,CURSOR]}
    local wrapped=${open}${text}${close}
    BUFFER="${BUFFER[1,MARK]}${wrapped}${BUFFER[CURSOR+1,-1]}"
    (( CURSOR += 2 ))
    [[ -n $ORIG ]] && { MARK=$CURSOR; CURSOR=$ORIG; }
  }
  single_quote() { wrap_region "'" "'"; }
  double_quote() { wrap_region '"' '"'; }
  wrap_parens() { wrap_region '(' ')'; }
  wrap_brackets() { wrap_region '[' ']'; }
  wrap_braces() { wrap_region '{' '}'; }

  show_keys() { zle -M "received: ${(q-)KEYS}"; }
}
declare_custom_widgets

function create_zle_custom_widgets { 
  zle -N overwrite_mode

  zle -N delete_char
  zle -N backward_delete_char

  zle -N delete_word
  zle -N backward_delete_word

  zle -N backward_char
  zle -N forward_char
  zle -N select_backward_char
  zle -N select_forward_char

  zle -N backward_word
  zle -N forward_word
  zle -N select_backward_word
  zle -N select_forward_word

  zle -N single_quote
  zle -N double_quote

  zle -N wrap_parens
  zle -N wrap_brackets
  zle -N wrap_braces

  zle -N show_keys

  zle -N interactive_cd
}
create_zle_custom_widgets

function terminal_widget_replacer {
  bindkey $'\e[2~' toggle_overwrite_mode
}
terminal_widget_replacer

function terminal_keybinder {
  bindkey $'\e[1;5A' up-line-or-history
  bindkey $'\eO1;5A' up-line-or-history
  bindkey $'\e[1;5B' down-line-or-history
  bindkey $'\eO1;5B' down-line-or-history
  bindkey $'\e[5~'   beginning-of-history
  bindkey $'\eO5~'   beginning-of-history
  bindkey $'\e[6~'   end-of-history
  bindkey $'\eO6~'   end-of-history
  bindkey $'\e[H'    beginning-of-line
  bindkey $'\eOH'    beginning-of-line
  bindkey $'\e[F'    end-of-line
  bindkey $'\eOF'    end-of-line
  bindkey $'\e[C'    forward_char
  bindkey $'\eOC'    forward_char
  bindkey $'\e[1;2C' select_forward_char
  bindkey $'\eO1;2C' select_forward_char
  bindkey $'\e[D'    backward_char
  bindkey $'\eOD'    backward_char
  bindkey $'\e[1;6D' select_backward_word
  bindkey $'\eO1;6D' select_backward_word
  bindkey $'\e[1;5C' forward_word
  bindkey $'\eO1;5C' forward_word
  bindkey $'\e[1;6C' select_forward_word
  bindkey $'\eO1;6C' select_forward_word
  bindkey $'\e[1;5D' backward_word
  bindkey $'\eO1;5D' backward_word
  bindkey $'\e[1;2D' select_backward_char
  bindkey $'\eO1;2D' select_backward_char
  
  bindkey $'\e[3~'   delete_char
  bindkey $'\eO3~'   delete_char
  bindkey $'\e[3;5~' delete_word
  bindkey $'\eO3;5~' delete_word
  bindkey $'^?'      backward_delete_char
  bindkey $'^W'      backward_delete_word
  bindkey $'^H'      backward_delete_word
  bindkey $'\''      single_quote
  bindkey $'"'       double_quote

  bindkey $'('       wrap_parens
  bindkey $'['       wrap_brackets
  bindkey $'{'       wrap_braces

  bindkey $'^Z'      undo
  bindkey $'^_'      redo
  bindkey $'\e[1;6Z' redo
  bindkey $'\eO1;6Z' redo
}
terminal_keybinder