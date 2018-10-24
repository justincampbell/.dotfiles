export BREW_PREFIX=/usr/local/opt
export BROWSER=open
export CLICOLOR=true
export EC2_HOME=$([ -d /usr/local/Cellar/ec2-api-tools ] && find /usr/local/Cellar/ec2-api-tools -type d -name libexec | head -n 1)
export EDITOR=nvim
export FORECAST_IO_API_KEY=$(cat ~/.forecast)
export GOBIN=$GOPATH/bin
export GOPATH=$(stat -f ~/Code/go)
export HISTCONTROL=ignoreboth
export HISTSIZE=10000

export PATH=$GOPATH/bin:$PATH # Go
export PATH=$HOME/.dotfiles/bin:$PATH # Dotfiles
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # Homebrew
export PATH=node_modules/.bin:/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=bin:$PATH

# ruby
source $BREW_PREFIX/chruby/share/chruby/chruby.sh
print_ruby() { basename $RUBY_ROOT ;}
detect_chruby() { chruby $(cat .ruby-version) && print_ruby ;}
[ -f .ruby-version ] && detect_chruby || chruby 2.5
alias 22='chruby ruby-2.2 && print_ruby'
alias 23='chruby ruby-2.3 && print_ruby'
alias 24='chruby ruby-2.4 && print_ruby'
alias 25='chruby ruby-2.5 && print_ruby'

# node
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use stable > /dev/null

# git + prompt
alias git=hub # Git ♥ 's GitHub
clone() {
  cd ~/Code
  git clone $1
  cd $(echo $1 | cut -f 2 -d /)
}
source $BREW_PREFIX/git/etc/bash_completion.d/git-completion.bash
source ~/.dotfiles/prompt.sh
git_changed() {
  echo "$(git changed) $(git status --short | sed -e 's/^ //' | cut -f 2 -d " ")" | sort | uniq
}

# neovim
alias vim=nvim

# Gui aliases
google() { open "https://www.google.com/search?q=$@" ;}
graphviz() { open "$@" -a /Applications/Graphviz.app ;}
marked() { open "$@" -a /Applications/Marked.app ;}

# use
source /usr/local/share/use/use.sh

# Fuzzy finders
branch() {
  git checkout ${1:-$(
  git for-each-ref \
    --sort=-committerdate \
    --format='%(refname:short)' \
    refs/heads/ \
    | pick
  )}
}
code() { cd ~/Code; cd ${1:-$(ls -at ~/Code | pick)} ;}
cookbook() { cd ~/Code/cookbooks/${1:-$(ls -at ~/Code/cookbooks | pick)} ;}
codego() {
  cd $GOPATH/src/${1:-$(
  find $GOPATH/src -type d -maxdepth 3 | \
    grep "src/.*/.*/.*$" | \
    cut -f 7-9 -d "/" | \
    pick
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
pr() {
  pr=$1
  if [[ $pr =~ ^[0-9]+$ ]]; then
    shift
  else
    issue=$(hub issue | head -n 1)
    pr=$(echo $issue | cut -f 1 -d "]" | xargs echo)
    echo -e "Using latest PR\n$issue)"
  fi
  app=$(git remote -v | grep ^staging | grep "(push)" | cut -f 4 -d "/" | cut -f 1 -d ".")-pr-$pr
  heroku $@ --app $app
}
promote() { staging pipelines:promote ;}

# Start Tmux if not running
[ -z "$TMUX" ] && (tmux attach || tmux)

# Show q-queue status
q-queue -s

publicip() {
  curl https://api.ipify.org
}

charles() {
  export ALL_PROXY=http://localhost:8888
  export FTP_PROXY=$ALL_PROXY
  export HTTPS_PROXY=$ALL_PROXY
  export HTTP_PROXY=$ALL_PROXY
  export RSYNC_PROXY=$ALL_PROXY
  export ftp_proxy=$ALL_PROXY
  export http_proxy=$ALL_PROXY
  export https_proxy=$ALL_PROXY
  export rsync_proxy=$ALL_PROXY

  export SSL_CERT_FILE=~/.charles/charles-ssl-proxying-certificate.pem
}

fix_camera() {
  sudo killall VDCAssistant
}

# reset return code to 0
true
