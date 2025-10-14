google() { open "https://www.google.com/search?q=$@" ;}

# Fuzzy finders
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Aliases
alias p=pomodoro

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
  if [ ! -z "$CODESPACES" ]; then
    cd /workspaces/${1:-$(
      find /workspaces -maxdepth 1 -type d | \
        cut -f 3 -d "/" | \
        fzf
    )}
  else
    cd ~/Code/${1:-$(
      find ~/Code -maxdepth 2 -type d | \
        grep ".*/.*$" | \
        cut -f 5-6 -d "/" | \
        fzf
      )}
  fi
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

meeting() {
  slack_dnd 25
  slack_status :zoom: 25 Meeting
  hueadm group "Justin's Office" reset > /dev/null
  hueadm group "Justin's Office" "$(hue_temperature)" bri=$(hue_brightness) > /dev/null
}

tadam() {
  open "tadam://start?time=25min"
}

rspec-changes() {
  local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/@@')

  if [ -z "$default_branch" ]; then
    default_branch="origin/main"
  fi

  local changed_specs=$(
    (git diff --name-only --relative "$default_branch"...HEAD; git diff --name-only --relative) \
      | grep '_spec\.rb$' \
      | sort -u
  )

  if [ -z "$changed_specs" ]; then
    echo "No changed spec files found"
    return 1
  fi

  echo rspec $changed_specs "$@"

  if [ -f Gemfile ]; then
    bundle exec rspec $changed_specs "$@"
  else
    rspec $changed_specs "$@"
  fi
}
