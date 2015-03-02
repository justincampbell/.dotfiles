export BREW_PREFIX=/usr/local/opt
export BROWSER=open
export CLICOLOR=true
export DOCKER_HOST=tcp://192.168.59.103:2375
export EC2_HOME=$([ -d /usr/local/Cellar/ec2-api-tools ] && find /usr/local/Cellar/ec2-api-tools -type d -name libexec | head -n 1)
export EDITOR=vim
export FORECAST_IO_API_KEY=$(cat ~/.forecast)
export GOBIN=$GOPATH/bin
export GOPATH=$(stat -f ~/Code/go)
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export JAVA_HOME="$(/usr/libexec/java_home)"

export PATH=$GOPATH/bin:$PATH # Go
export PATH=$HOME/.bin:$PATH # Dotfiles
export PATH=$HOME/.cabal/bin:$HOME/Library/Haskell/bin:$PATH # Haskell/Cabal
export PATH=$HOME/.dotfiles/bin:$PATH # Dotfiles
export PATH=$HOME/.nimble/bin:$PATH # Nim
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # Homebrew
export PATH=/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=bin:$PATH

# ruby
source $BREW_PREFIX/chruby/share/chruby/chruby.sh
print_ruby() { basename $RUBY_ROOT ;}
detect_chruby() { chruby $(cat .ruby-version) && print_ruby ;}
[ -f .ruby-version ] && detect_chruby || chruby 2.2
alias 19='chruby ruby-1.9 && print_ruby'
alias 20='chruby ruby-2.0 && print_ruby'
alias 21='chruby ruby-2.1 && print_ruby'
alias 22='chruby ruby-2.2 && print_ruby'
alias jr='chruby jruby && print_ruby'

# node
source $BREW_PREFIX/nvm/nvm.sh
nvm use 0.11 > /dev/null

# git + prompt
alias git=hub # Git ♥ 's GitHub
clone() {
  cd ~/Code
  git clone $1
  cd $(echo $1 | cut -f 2 -d /)
}
source $BREW_PREFIX/git/etc/bash_completion.d/git-completion.bash
source ~/.dotfiles/prompt.sh

# neovim
alias vim=nvim

# Gui aliases
google() { open "http://www.google.com/search?q=$@" ;}
marked() { open $@ -a /Applications/Marked.app ;}

# use
source $BREW_PREFIX/use/share/use/use.sh

# Fuzzy finders
branch() { git checkout ${1:-$(git branch | grep -v "^* "| selecta)} ;}
code() { cd ~/Code; cd ${1:-$(ls -at ~/Code | selecta)} ;}
cookbook() { cd ~/Code/cookbooks/${1:-$(ls -at ~/Code/cookbooks | selecta)} ;}
gocode() {
  cd $GOPATH/src/${1:-$(
  find $GOPATH/src -type d -maxdepth 3 | \
    grep "src/.*/.*/.*$" | \
    cut -f 7-9 -d "/" | \
    selecta
  )}
}

# Directory jumping
cdcode() { cd ~/Code ;}
cdgo() { cd $GOPATH ;}
cddotfiles() { cd ~/.dotfiles ;}
cdnotes() { cd ~/Notes ;}
cdroot() { cd `git rev-parse --git-dir`/.. ;}

# remove Dropbox when opening new terminal tabs
[[ -d ${PWD/Dropbox\//} ]] && cd ${PWD/Dropbox\//}

# vim-brained
alias :q=exit

# Lock the screen
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Show screen size
alias xy="tput cols; tput lines"

# Heroku
production() { heroku $@ --remote production ;}
staging() { heroku $@ --remote staging ;}

# Start wemux if it's not already running elsewhere
pgrep -q tmux\|tmate\|wemux || wemux

# Show q-queue status
q-queue -s

# reset return code to 0
true
