#List of functions to create custom zle widgets and bind keys to them.
function declare_custom_widgets {
  toggle_overwrite_mode() {
    if [[ -z $_overwrite_mode_in_on__ ]]; then
      _overwrite_mode_in_on__=true
      echo -ne '\e[1 q\e[?12h'  # Blinking block
    else
      unset _overwrite_mode_in_on__
      echo -ne '\e[3 q\e[?12h'  # Blinking underline
    fi
    zle overwrite-mode
  }
}
declare_custom_widgets

function create_zle_custom_widgets { 
  zle -N toggle_overwrite_mode
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
  bindkey '^[[C'    forward-char
  bindkey '^[[D'    backward-char
  bindkey '^[[3~'   delete-char
  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word
  bindkey '^[[1;3~' delete-word
}
terminal_keybinder