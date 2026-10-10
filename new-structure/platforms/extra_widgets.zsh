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

terminal_widget_replacer

function terminal_keybinder {

}
terminal_keybinder