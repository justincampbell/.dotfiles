which -s brew && brew update
which -s brew || ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

brew install \
  ack \
  chruby \
  git \
  hub \
  ruby-install \
  vim \
  watch \
  wemux
