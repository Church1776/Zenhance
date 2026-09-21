#List of functions to create custom zle widgets and bind keys to them.
function declare_custom_widgets {
  toggle_overwrite_mode() {
    zle overwrite-mode
    if [[ $ZLE_STATE == *"overwrite"* ]]; then
      echo -ne '\e[1 q\e[?12h'  # Blinking block
    else
      echo -ne '\e[3 q\e[?12h'  # Blinking underline
    fi
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

  backward_delete_char() {(( REGION_ACTIVE )) && zle kill-region; zle backward-delete-char;}
  backward_delete_word() {(( REGION_ACTIVE )) && zle kill-region; zle backward-delete-word;}

  wrap_region() {
    local open="$1"
    local close="$2"
    (( REGION_ACTIVE )) || { zle self-insert; return; }
    (( MARK > CURSOR )) && { local -i ORIG=CURSOR; CURSOR=$MARK; MARK=$ORIG }
    local text=${BUFFER[MARK+1,CURSOR]}
    local wrapped=${open}${text}${close}
    BUFFER="${BUFFER[1,MARK]}${wrapped}${BUFFER[CURSOR+1,-1]}"
    (( CURSOR++, CURSOR++ ))
  }
  single_quote() { wrap_region "'" "'"; }
  double_quote() { wrap_region '"' '"'; }
  wrap_parens() { wrap_region '(' ')'; }
  wrap_brackets() { wrap_region '[' ']'; }
  wrap_braces() { wrap_region '{' '}'; }
}
declare_custom_widgets

function create_zle_custom_widgets { 
  zle -N toggle_overwrite_mode

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
}
create_zle_custom_widgets

function terminal_widget_replacer {
  bindkey '^[[2~' toggle_overwrite_mode
}
terminal_widget_replacer

function terminal_keybinder {
  bindkey '^[[1;5A' up-line-or-history
  bindkey '^[[1;5B' down-line-or-history
  bindkey '^[[5~'   beginning-of-history
  bindkey '^[[6~'   end-of-history
  bindkey '^[[H'    beginning-of-line
  bindkey '^[[F'    end-of-line
  bindkey '^[[C'    forward_char
  bindkey '^[[1;2C' select_forward_char
  bindkey '^[[D'    backward_char
  bindkey '^[[1;6D' select_backward_word
  bindkey '^[[1;5C' forward_word
  bindkey '^[[1;6C' select_forward_word
  bindkey '^[[1;5D' backward_word
  bindkey '^[[1;2D' select_backward_char

  bindkey '^[[3~'   delete_char
  bindkey '^[[3;5~' delete_word
  bindkey '^?'      backward_delete_char
  bindkey '^W'      backward_delete_word

  bindkey "'"       single_quote
  bindkey '"'       double_quote

  bindkey '('       wrap_parens
  bindkey '['       wrap_brackets
  bindkey '{'       wrap_braces
}
terminal_keybinder