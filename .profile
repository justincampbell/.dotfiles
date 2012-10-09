export BROWSER=open
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export PATH=bin:$HOME/.rbenv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin/:$HOME/.dotfiles/bin:$PATH

# git
eval "$(hub alias -s)" # Git ♥ 's GitHub
[[ $- == *i* ]]  &&  . ~/.dotfiles/git-prompt.sh && source ~/.dotfiles/git-completion.bash

# rvm
[[ -s ".rvm/scripts/rvm" ]] && source ".rvm/scripts/rvm" && chmod +x $rvm_path/hooks/after_cd_bundler

# rbenv
eval "$(rbenv init -)"

# use
alias use="source _use"
