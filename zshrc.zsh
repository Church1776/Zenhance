# Lines configured by zsh-newuser-install
HISTFILE=${ZDOTDIR:-$HOME}/.zhistory
HISTSIZE=1000
SAVEHIST=10000
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ${ZDOTDIR:-$HOME}/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ${ZDOTDIR:-$HOME}/.config/zsh/zsh-interactive-toolkit/zsh-interactive-toolkit.zsh
