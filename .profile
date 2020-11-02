export BASH_SILENCE_DEPRECATION_WARNING=1
export BREW_PREFIX=/usr/local/opt
export BROWSER=open
export CLICOLOR=true
export EC2_HOME=$([ -d /usr/local/Cellar/ec2-api-tools ] && find /usr/local/Cellar/ec2-api-tools -type d -name libexec | head -n 1)
export EDITOR=nvim
export FORECAST_IO_API_KEY="$(cat ~/.forecast)"
export FZF_DEFAULT_COMMAND='fd --type f'
export GO111MODULE=on
export GOBIN=$GOPATH/bin
export GOPATH=$(stat -f ~/Code/go)
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export SLACK_TOKEN="$(cat ~/.slack)"

export PATH=$GOPATH/bin:$PATH # Go
export PATH=$HOME/.dotfiles/bin:$PATH # Dotfiles
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # Homebrew
export PATH=node_modules/.bin:/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=bin:$PATH

# Functions
source ~/.dotfiles/functions.sh

# ruby
source $BREW_PREFIX/chruby/share/chruby/chruby.sh
print_ruby() { basename $RUBY_ROOT ;}
detect_chruby() { chruby $(cat .ruby-version) && print_ruby ;}
[ -f .ruby-version ] && detect_chruby || chruby 2.7
alias 23='chruby ruby-2.3 && print_ruby'
alias 24='chruby ruby-2.4 && print_ruby'
alias 25='chruby ruby-2.5 && print_ruby'
alias 26='chruby ruby-2.6 && print_ruby'
alias 27='chruby ruby-2.7 && print_ruby'

# node
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

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

# use
source /usr/local/share/use/use.sh

# remove Dropbox when opening new terminal tabs
[[ -d ${PWD/Dropbox\//} ]] && cd ${PWD/Dropbox\//}

# vim-brained
alias :q=exit

# Lock the screen
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Start Tmux if not running
[ -z "$TMUX" ] && (tmux attach || tmux)

# Show q-queue status
q-queue -s

# reset return code to 0
true
