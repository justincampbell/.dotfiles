#!/bin/bash -e

formulae=(
  ag
  bash
  brew-cask
  chruby
  cloc
  git
  heroku-toolbelt
  hub
  ruby-install
  tree
  vim
  watch
  wemux
  wget
)

casks=(
  slate
)

which -s brew && brew update
which -s brew || ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

brew doctor || exit 1

brew tap | grep "cask" > /dev/null || brew tap phinze/homebrew-cask

for formula in "${formulae[@]}"; do
  brew install $formula || brew upgrade $formula
done

for cask in "${casks[@]}"; do
  brew cask install $cask --force
done

grep /usr/local/bin/bash /etc/shells > /dev/null || (echo "
Homebrew Bash needs some additional setup:

  sudo sh -c 'echo /usr/local/bin/bash >> /etc/shells'
  chsh -s /usr/local/bin/bash
" && exit 1)
