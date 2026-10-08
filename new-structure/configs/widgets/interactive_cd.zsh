# Interactive cd widget for zsh using fzf filter and fd finder.

function interactive_cd() {
  ZIT_WIDGET=1
  local beginning_root="$PWD"
  local root="$PWD"
  local level=0
  local display=""
  local oldpath="./"
  local diverged=0
  local origpathlvl=""
  local response action chosen query
  local -a response_lines
  local fd_cmd=${ZIT_FD_CMD:-fd}
  local fzf_cmd=${ZIT_FZF_CMD:-fzf}

  [[ $LBUFFER == cd || $LBUFFER == 'cd '* ]] || {
    zle expand-or-complete
    return
  }

  query=${LBUFFER#cd }
  zle -I

  while true; do
    if ! response=$(
      {
        print -r -- .
        $fd_cmd --type d --hidden --follow --max-depth 1
      } |
        "$fzf_cmd" \
          --height=40% \
          --layout=reverse \
          --scheme=path \
          --prompt="Level:$level  Diverged:$diverged  OrigPathLvl:$origpathlvl  > $display" \
          --expect=ctrl-c \
          +m \
          --bind='enter:become(printf "accept\n%s\n" {})' \
          --bind='right:become(printf "descend\n%s\n" {})' \
          --bind='tab:become(printf "descend\n%s\n" {})' \
          --bind='shift-tab:become(printf "parent\n%s\n" {})' \
          --bind='left:become(printf parent)' \
    ); then
      zle reset-prompt
      return
    fi

    response_lines=("${(@f)response}")
    action=${response_lines[1]}
    chosen=${response_lines[2]}

    case $action in
      descend)
        [[ $chosen == . ]] && continue
        oldpath="${root:t}/"
        cd -- "$chosen" 2>/dev/null || continue
        root="$PWD"
        (( --level ))
        if [[ "$chosen" == "${origpathlvl%%/*}/" ]]; then
          diverged=0
          origpathlvl="${origpathlvl#*/}"
          display="${display:h}/"
          [[ $display == './' ]] && display=""
        else
          diverged=1
          display+="$chosen"
        fi
        ;;
      parent)
        [[ $root == / ]] && continue
        oldpath="${root:t}/"
        cd -- ".." 2>/dev/null || continue
        root="$PWD"
        (( ++level ))
        if [[ $diverged -eq 1 ]]; then
          display="${display:h}/"
          [[ $display == './' ]] && { display=""; diverged=0; }
        else
          display+="../"
          origpathlvl="${oldpath}${origpathlvl}"
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
      ctrl-c)
        cd -- "$beginning_root" 2>/dev/null
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