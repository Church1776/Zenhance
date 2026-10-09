#List of functions to create custom zle widgets and bind keys to them.

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

  zle -N wrap_region
  zle -N open_parens
  zle -N open_brackets
  zle -N open_braces
  zle -N close_parens
  zle -N close_brackets
  zle -N close_braces

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
  
  bindkey $'\e[2~'   overwrite_mode
  bindkey $'\e[3~'   delete_char
  bindkey $'\eO3~'   delete_char
  bindkey $'\e[3;5~' delete_word
  bindkey $'\eO3;5~' delete_word
  bindkey '^?'      backward_delete_char
  bindkey '^W'      backward_delete_word
  bindkey '^H'      backward_delete_word
  bindkey $'\e[Z'    interactive_cd
  bindkey $'\eOZ'    interactive_cd
  bindkey "'"       single_quote
  bindkey '"'       double_quote

  bindkey '('       open_parens
  bindkey '['       open_brackets
  bindkey '{'       open_braces
  bindkey ')'       close_parens
  bindkey ']'       close_brackets
  bindkey '}'       close_braces

  bindkey '^X'      describe-key-briefly
  bindkey '^Z'      undo
  bindkey '^_'      redo
  bindkey $'\e[1;6Z' redo
  bindkey $'\eO1;6Z' redo
}
terminal_keybinder