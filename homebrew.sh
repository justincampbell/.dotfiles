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

brew tap | grep "cask" > /dev/null || brew tap phinze/homebrew-cask

for formula in "${formulae[@]}"; do
  brew install $formula || brew upgrade $formula
done

for cask in "${casks[@]}"; do
  brew cask install $cask --force
done
