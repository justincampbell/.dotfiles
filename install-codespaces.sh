#!/bin/bash -ex

echo "deb http://deb.debian.org/debian main contrib non-free" \
  | sudo tee -a /etc/apt/sources.list
sudo apt-get update && sudo apt-get upgrade -y

# Packages
sudo apt -o DPkg::Lock::Timeout=600 install \
  athena-jot \
  bat \
  fd-find \
  fuse \
  fzf \
  python-dev \
  python3-dev \
  python3-pip \
  silversearcher-ag \
  software-properties-common \
  tmux \
  tree \
  -y

if ! [[ -x /usr/bin/bat ]]; then
  sudo ln -s $(which batcat) /usr/bin/bat
fi
if ! [[ -x /usr/bin/fd ]]; then
  sudo ln -s $(which fdfind) /usr/bin/fd
fi

# Bat Theme
curl -fLo "$(bat --config-dir)/themes/railscasts/railscasts.tmTheme" --create-dirs \
  https://raw.githubusercontent.com/tdm00/sublime-theme-railscasts/master/RailsCastsColorScheme.tmTheme
bat cache --build

# Node
sudo rm -rf /usr/local/share/nvm
unset NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
{ set +x; } 2> /dev/null
\. ~/.nvm/nvm.sh
nvm install stable
set -x

# Neovim
cd $(mktemp -d) && \
  curl -fLO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
  sudo chmod u+x nvim.appimage && \
  sudo mv nvim.appimage /usr/local/bin/nvim

sudo apt install python3-neovim -y
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim --headless +PlugInstall +qa
