#!/bin/bash -e

which -s brew && brew update
which -s brew || ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

brew tap homebrew/binary
brew tap phinze/cask
brew tap thoughtbot/formulae

formulae=(
  ag
  boot2docker
  brew-cask
  chruby
  cloc
  git
  heroku-toolbelt
  hub
  nvm
  reattach-to-user-namespace
  ruby-install
  tree
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
  echo "
\`brew doctor\` failed. Please resolve issues before continuing.
  "
  exit 1
fi

brew tap | grep "cask" > /dev/null || brew tap phinze/homebrew-cask

for formula in "${formulae[@]}"; do
  brew install $formula || brew upgrade $formula
done

for cask in "${casks[@]}"; do
  brew cask install $cask
done
