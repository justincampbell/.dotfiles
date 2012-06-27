export BROWSER=open
export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export PATH=bin:/usr/local/bin:/usr/local/sbin:$PATH

eval "$(hub alias -s)" # Git ♥ 's GitHub

[[ $- == *i* ]]   &&   . ~/.dotfiles/git-prompt.sh
source ~/.dotfiles/git-completion.bash

[[ -s ".rvm/scripts/rvm" ]] && source ".rvm/scripts/rvm"
chmod +x $rvm_path/hooks/after_cd_bundler

