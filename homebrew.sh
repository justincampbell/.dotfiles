#!/bin/bash -e

which -s brew && brew update
which -s brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap homebrew/binary
brew tap justincampbell/formulae
brew tap thoughtbot/formulae

formulae=(
  ag
  boot2docker
  caskroom/cask/brew-cask
  chruby
  cloc
  dotmusic
  emoji-weather
  git
  heroku-toolbelt
  hub
  nvm
  q-queue
  reattach-to-user-namespace
  rr
  ruby-install
  selecta
  tmux-pomodoro
  tmux-status-bar
  tree
  use
  vim
  watch
  wemux
  wget
)

casks=(
  iterm2
  qlcolorcode
  qlmarkdown
  qlstephen
  quicklook-csv
  quicklook-json
  slate
  sparrow
  vagrant
  virtualbox
)

if ! brew doctor; then
  echo "\`brew doctor\` failed. Please resolve issues before continuing."
  exit 1
fi

brew tap | grep "cask" > /dev/null || brew tap phinze/homebrew-cask

for formula in "${formulae[@]}"; do
  brew install $formula || brew upgrade $formula
done

for cask in "${casks[@]}"; do
  brew cask install $cask
done
