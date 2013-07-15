export BROWSER=open
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
export EDITOR=vim
export JAVA_HOME="$(/usr/libexec/java_home)"
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/.dotfiles/bin:$PATH

# git
eval "$(hub alias -s)" # Git ♥ 's GitHub
[[ $- == *i* ]]  &&  . ~/.dotfiles/git-prompt.sh && source ~/.dotfiles/git-completion.bash

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
RUBIES=(~/.rubies/*)
chruby 1.9.3

# use
alias use="source _use"

# remove Dropbox when opening new terminal tabs
[[ -d ${PWD/Dropbox\//} ]] && cd ${PWD/Dropbox\//}

# vim-brained
alias :q=exit

# prefer local bin/
export PATH=bin:$PATH

# Heroku
production() { heroku $@ --remote production ;}
staging() { heroku $@ --remote staging ;}

# reset return code to 0
true
