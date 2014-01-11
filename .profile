export BREW_PREFIX=/usr/local/opt
export BROWSER=open
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
export EDITOR=vim
export GOPATH=".gopath"
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export JAVA_HOME="$(/usr/libexec/java_home)"
export PATH=$HOME/.cabal/bin:$PATH # Haskell/Cabal
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/.dotfiles/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=bin:$PATH

# ruby
source $BREW_PREFIX/chruby/share/chruby/chruby.sh
[[ -f .ruby-version ]] || chruby 2.1.0
print_ruby() { basename $RUBY_ROOT ;}
detect_chruby() { chruby $(cat .ruby-version) && print_ruby ;}
alias 19='chruby ruby-1.9 && print_ruby'
alias 20='chruby ruby-2.0 && print_ruby'
alias 21='chruby ruby-2.1 && print_ruby'
alias jr='chruby jruby && print_ruby'

# node
source $BREW_PREFIX/nvm/nvm.sh
nvm use 0.10 > /dev/null

# git + prompt
alias git=hub # Git ♥ 's GitHub
source $BREW_PREFIX/git/etc/bash_completion.d/git-completion.bash
source ~/.dotfiles/prompt.sh

# use
alias use="source _use"

# remove Dropbox when opening new terminal tabs
[[ -d ${PWD/Dropbox\//} ]] && cd ${PWD/Dropbox\//}

# vim-brained
alias :q=exit

# The Silver Searcher
alias ack=ag

# StarCraft
alias starcraft_race="ruby -e 'puts %w[Terran Zerg Protoss].sample'"

# Heroku
production() { heroku $@ --remote production ;}
staging() { heroku $@ --remote staging ;}

# Start wemux if it's not already running elsewhere
[[ -x /tmp/wemux-wemux ]] || wemux

# reset return code to 0
true
