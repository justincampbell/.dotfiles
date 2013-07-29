#!/bin/bash -e

which -s brew && brew update
which -s brew || ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

packages=(
  ack
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

for package in "${packages[@]}"; do
  brew install $package || brew upgrade $package
done
