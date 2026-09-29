source "$ZENHANCE/enhancements/linux/$ID_LIKE/commands.zsh"

if [[ $READY_FOR_PRECMD ]]; then
  source "$ZENHANCE/enhancements/linux/$ID_LIKE/precmd.zsh"
fi