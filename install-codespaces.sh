#!/bin/bash -ex

sudo add-apt-repository ppa:neovim-ppa/stable --no-update -y
sudo apt update
sudo apt upgrade -y

# Packages
sudo apt -o DPkg::Lock::Timeout=600 install \
  athena-jot \
  bat \
  fd-find \
  neovim \
  python-dev \
  python3-dev \
  python3-pip \
  tmux \
  tree \
  -y

sudo ln -s $(which fdfind) /usr/bin/fd

# Bat Theme
curl -fLo "$(batcat --config-dir)/themes/railscasts/railscasts.tmTheme" --create-dirs \
  https://raw.githubusercontent.com/tdm00/sublime-theme-railscasts/master/RailsCastsColorScheme.tmTheme
batcat cache --build

# Neovim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim --headless +PlugInstall +qa

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh
