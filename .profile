export HISTCONTROL=ignoreboth
export HISTSIZE=10000

[[ $- == *i* ]]   &&   . ~/.dotfiles/git-prompt.sh

[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"

