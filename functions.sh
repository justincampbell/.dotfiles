google() { open "https://www.google.com/search?q=$@" ;}

# Fuzzy finders
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
branch() {
  git checkout ${1:-$(
  git for-each-ref \
    --sort=-committerdate \
    --format='%(refname:short)' \
    refs/heads/ \
    | fzf
  )}
}
code() {
  cd ~/Code/${1:-$(
  find ~/Code -type d -maxdepth 2 | \
    grep ".*/.*$" | \
    cut -f 5-6 -d "/" | \
    fzf
  )}
}

# Directory jumping
cddotfiles() { cd ~/.dotfiles ;}
cdroot() { cd `git rev-parse --git-dir`/.. ;}

# Show screen size
xy() {
  echo "$(tput cols)x$(tput lines)"
}

publicip() {
  curl https://api.ipify.org
}

# Returns nonzero if there's no internet connection
online() {
  scutil -r 8.8.8.8 | grep "^Reachable" > /dev/null
}

# Returns nonzero if I'm not at home.
at_home() {
  networksetup -getairportnetwork en0 | grep Campbell > /dev/null
}

hue_brightness() {
  hour=$(date +"%H")
  if [ "$hour" -ge 7 -a "$hour" -le 19 ]; then
    echo "254"
  else
    echo "192"
  fi
}

hue_temperature() {
  hour=$(date +"%H")
  if [ "$hour" -ge 7 -a "$hour" -le 19 ]; then
    echo "4500k"
  else
    echo "2700k"
  fi
}
