# If we're in a codespace, wait until it's done building.
if [[ "$CODESPACES" != "" ]]; then
  message="Finished configuring codespace"
  log="/workspaces/.codespaces/.persistedshare/creation.log"
  if ! grep -q "${message}" "${log}"; then
    tail -f "${log}" | sed "/${message}/ q"
  fi
fi

export BASH_SILENCE_DEPRECATION_WARNING=1
export BAT_THEME=railscasts
export BREW_PREFIX=/opt/homebrew/opt
export BROWSER=open
export CLICOLOR=true
export EDITOR=nvim
export FZF_DEFAULT_COMMAND='fd --type f'
export GPG_TTY=$(tty)
export HISTCONTROL=ignoreboth
export HISTSIZE=10000

export PATH=$HOME/.dotfiles/bin:$PATH # Dotfiles
export PATH=/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:$PATH # Homebrew
export PATH=node_modules/.bin:/usr/local/share/npm/bin:$PATH # Node/NPM
export PATH=bin:$PATH

# Functions
source ~/.dotfiles/functions.sh

# Go
if [[ -z "$GOPATH" ]]; then
  export GOPATH=$(stat -f ~/Code/go)
  export GOBIN=$GOPATH/bin
  export PATH=/usr/local/opt/go/bin:$GOPATH/bin:$PATH
fi

# Ruby
if [ -x "$(command -v chruby)" ]; then
  source $BREW_PREFIX/chruby/share/chruby/chruby.sh
  print_ruby() { basename $RUBY_ROOT ;}
  detect_chruby() { chruby $(cat .ruby-version) && print_ruby ;}
  [ -f .ruby-version ] && detect_chruby || chruby ruby-3.1
  alias 27='chruby ruby-2.7 && print_ruby'
  alias 30='chruby ruby-3.0 && print_ruby'
  alias 31='chruby ruby-3.1 && print_ruby'
fi

# Node
if [ "$NVM_DIR" != ~/.nvm ]; then
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  [ -f .node-version ] && nvm use
fi

# Git + Prompt
clone() {
  org=$(echo $1 | cut -f 1 -d /)
  repo=$(echo $1 | cut -f 2 -d /)
  mkdir -p ~/Code/$org
  cd ~/Code/$org
  gh repo clone $org/$repo
  cd $repo
}
source ~/.dotfiles/prompt.sh
git_changed() {
  echo "$(git changed) $(git status --short | sed -e 's/^ //' | cut -f 2 -d " ")" | sort | uniq
}

# neovim
alias vi=nvim
alias vim=nvim

# use
if [[ -f /usr/local/share/use/use.sh ]]; then
  source /usr/local/share/use/use.sh
fi

# remove Dropbox when opening new terminal tabs
[[ -d ${PWD/Dropbox\//} ]] && cd ${PWD/Dropbox\//}

# Beep
beep() { osascript -e "beep $@"; }

# vim-brained
alias :q=exit

# Lock the screen
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# tmux
if [ -z "$TMUX" ]; then # Only do any of this if we're not inside a tmux session.
  if tmux has-session; then
    if ! tmux list-clients | grep attached > /dev/null; then
      # If there is a session, only attach to it if no other clients are attached.
      tmux attach
    fi
  else
    # If there are no tmux sessions, start one.
    tmux
  fi
fi

# Show q-queue status
if [ -x "$(command -v q-queue)" ]; then
  q-queue -s
fi

# reset return code to 0
true
