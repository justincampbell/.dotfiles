#!/bin/bash -ex

ln -fs ~/.dotfiles/.agignore ~/.agignore
ln -fs ~/.dotfiles/.gemrc ~/.gemrc
ln -fs ~/.dotfiles/.git_commit_template ~/.git_commit_template
ln -fs ~/.dotfiles/.hushlogin ~/.hushlogin
ln -fs ~/.dotfiles/.irbrc ~/.irbrc
ln -fs ~/.dotfiles/.profile ~/.profile
ln -fs ~/.dotfiles/.rdebugrc ~/.rdebugrc
ln -fs ~/.dotfiles/.slate ~/.slate
ln -fs ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -fs ~/.dotfiles/.vimrc ~/.vimrc

mkdir -p ~/Code

# git
git config --global alias.changed 'diff --name-only master..HEAD'
git config --global alias.changelog 'log --no-merges --pretty=format:"%s (%an)"'
git config --global alias.contributors 'shortlog --summary --email --numbered'
git config --global alias.graph 'log --all --date=relative --decorate --graph --oneline'
git config --global alias.ignore '!gitignoreio() { curl https://www.gitignore.io/api/$@ ;}; gitignoreio'
git config --global color.ui true
git config --global commit.template ~/.git_commit_template
git config --global github.user "justincampbell"
git config --global help.autocorrect 25
git config --global pull.ff only
git config --global push.default simple
git config --global user.email "justin@justincampbell.me"
git config --global user.name "Justin Campbell"
git config --global web.browser open

# bundler
which bundle && bundle config --global jobs `sysctl -n hw.ncpu`

# vim-plug
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
