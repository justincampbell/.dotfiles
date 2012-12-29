cd ~

ln -s .dotfiles/.ackrc ~/.ackrc
ln -s .dotfiles/.gemrc ~/.gemrc
ln -s .dotfiles/.git_commit_template ~/.git_commit_template
ln -s .dotfiles/.irbrc ~/.irbrc
ln -s .dotfiles/.profile ~/.profile
ln -s .dotfiles/.tmux.conf ~/.tmux.conf
ln -s .dotfiles/.vimrc ~/.vimrc

git config --global --add color.ui true
git config --global --add commit.template ~/.git_commit_template
git config --global --add user.email "justin@justincampbell.me"
git config --global --add user.name "Justin Campbell"
git config --global --add web.browser open

