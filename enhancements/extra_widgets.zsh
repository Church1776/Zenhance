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
  backward_char() {(( REGION_ACTIVE )) && zle deactivate-region; zle backward-char;}
  select_backward_char() {(( REGION_ACTIVE )) || zle set-mark-command; zle backward-char;}

  forward_char() {(( REGION_ACTIVE )) && zle deactivate-region; zle forward-char;}
  select_forward_char() {(( REGION_ACTIVE )) || zle set-mark-command; zle forward-char;}

  backward_word() {(( REGION_ACTIVE )) && zle deactivate-region; zle backward-word;}
  select_backward_word() {(( REGION_ACTIVE )) || zle set-mark-command; zle backward-word;}

  forward_word() {(( REGION_ACTIVE )) && zle deactivate-region; zle forward-word;}
  select_forward_word() {(( REGION_ACTIVE )) || zle set-mark-command; zle forward-word;}

  delete_char() { if (( REGION_ACTIVE )); then zle kill-region; else zle delete-char; fi }
  delete_word() { if (( REGION_ACTIVE )); then zle kill-region; else zle delete-word; fi }

  backward_delete_char() { if (( REGION_ACTIVE )); then zle kill-region; else zle backward-delete-char; fi }
  backward_delete_word() { if (( REGION_ACTIVE )); then zle kill-region; else zle backward-delete-word; fi }
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
  bindkey '^[[1;3~' delete_word
  bindkey '^?'      backward_delete_char
  bindkey '^W'      backward_delete_word
}
terminal_keybinder