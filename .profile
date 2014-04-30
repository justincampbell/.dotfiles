export BREW_PREFIX=/usr/local/opt
export BROWSER=open
export EC2_HOME=$(find /usr/local/Cellar/ec2-api-tools -type d -name libexec | head -n 1)
export EDITOR=vim
export GOPATH=$(stat -f ~/.gopath)
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export JAVA_HOME="$(/usr/libexec/java_home)"

export PATH=$GOPATH/bin:$PATH # Go
export PATH=$HOME/.bin:$PATH # Dotfiles
export PATH=$HOME/.cabal/bin:$PATH # Haskell/Cabal
export PATH=$HOME/.dotfiles/bin:$PATH # Dotfiles
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # Homebrew
export PATH=/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=bin:$PATH

# ruby
source $BREW_PREFIX/chruby/share/chruby/chruby.sh
print_ruby() { basename $RUBY_ROOT ;}
detect_chruby() { chruby $(cat .ruby-version) && print_ruby ;}
[ -f .ruby-version ] && detect_chruby || chruby 2.0.0
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

# boot2docker
alias docker='docker -H tcp://0.0.0.0:4243'

# Gui aliases
google() { open "http://www.google.com/search?q=$@" ;}
marked() { open $@ -a /Applications/Marked.app ;}

# use
source $BREW_PREFIX/use/share/use/use.sh

# Directory jumping
code() {
  code_directory=${1:-`ls -at ~/Code | selecta`}
  cd ~/Code/$code_directory
}
cdcode() { cd ~/Code ;}
cddotfiles() { cd ~/.dotfiles ;}
cdnotes() { cd ~/Notes ;}
cdroot() { cd `git rev-parse --git-dir`/.. ;}

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
pgrep -q tmux\|tmate\|wemux || wemux

# reset return code to 0
true
