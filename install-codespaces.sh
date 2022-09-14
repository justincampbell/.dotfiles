#!/bin/bash -ex

# Packages
sudo apt -o DPkg::Lock::Timeout=600 install \
  athena-jot \
  bat \
  fd-find \
  python-dev \
  python3-dev \
  python3-pip \
  silversearcher-ag \
  software-properties-common \
  tmux \
  tree \
  -y

sudo ln -s $(which fdfind) /usr/bin/fd
if ! [[ -x /usr/bin/bat ]]; then
  sudo ln -s $(which batcat) /usr/bin/bat
fi

# Bat Theme
curl -fLo "$(bat --config-dir)/themes/railscasts/railscasts.tmTheme" --create-dirs \
  https://raw.githubusercontent.com/tdm00/sublime-theme-railscasts/master/RailsCastsColorScheme.tmTheme
bat cache --build

# Neovim
cd $(mktemp -d) && \
  curl -fLo nvim-linux64.deb https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb && \
  sudo apt install ./nvim-linux64.deb -y
sudo apt install python3-neovim -y
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim --headless +PlugInstall +qa

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh
