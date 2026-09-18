# Lines configured by zsh-newuser-install
HISTFILE=$(cygpath -u $USERPROFILE)/.zhistory
HISTSIZE=1000
SAVEHIST=10000
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename $(cygpath -u $USERPROFILE)/.zshrc

autoload -Uz compinit
compinit
# End of lines added by compinstall

