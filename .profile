export BROWSER=open
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
export EDITOR=vim
export GOPATH=".gopath"
export JAVA_HOME="$(/usr/libexec/java_home)"
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export PATH=/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=$HOME/.cabal/bin:$PATH # Haskell/Cabal
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/.dotfiles/bin:$PATH
export PATH=bin:$PATH

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
[[ -f .ruby-version ]] || chruby 2.1.0
detect_chruby() { chruby $(cat .ruby-version) && cat .ruby-version ;}

# git + prompt
eval "$(hub alias -s)" # Git ♥ 's GitHub
source /usr/local/etc/bash_completion.d/git-completion.bash
source ~/.dotfiles/prompt.sh

# use
alias use="source _use"

# remove Dropbox when opening new terminal tabs
[[ -d ${PWD/Dropbox\//} ]] && cd ${PWD/Dropbox\//}

# vim-brained
alias :q=exit

# The Silver Searcher
alias ack=ag

# Heroku
production() { heroku $@ --remote production ;}
staging() { heroku $@ --remote staging ;}

# Start wemux if it's not already running elsewhere
[[ -x /tmp/wemux-wemux ]] || wemux

# reset return code to 0
true
