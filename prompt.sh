#!/bin/bash

cyan=`tput setaf 6`
red=`tput setaf 1`
yellow=`tput setaf 3`
dark_gray=`tput setaf 241`
bold=`tput bold`
reset=`tput sgr0`

contains() {
  local list=$#
  local value=${!list}

  for ((i=1; i<$#; i++)) {
    if [ "${!i}" == "${value}" ]; then
      return 0
    fi
  }

  return 1
}

generate_random_color() {
  random_color="0"
  disallowed=("0" "8" "16" "17" "18" "59")

  until $(! contains "${disallowed[@]}" "$random_color"); do
    random_color=$(jot -r 1 1 230)
  done

  echo $random_color
}

random_color() {
  echo -n `tput setaf $(generate_random_color)`
}

function display_duration () {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

node_status() {
  if ! [[ -f .nvmrc || -f .node-version ]]; then
    return
  fi

  NODE_VERSION=$(node -v)
  if [[ -f .nvmrc ]]; then
    DESIRED_NODE_VERSION=$(cat .nvmrc)
  fi
  if [[ -f .node-version ]]; then
    DESIRED_NODE_VERSION=$(cat .node-version)
  fi

  if [[ "$DESIRED_NODE_VERSION" == lts/* ]]; then
    DESIRED_NODE_VERSION=$(nvm alias --no-colors $DESIRED_NODE_VERSION | cut -f 3 -d " ")
  else
    DESIRED_NODE_VERSION="v$DESIRED_NODE_VERSION"
  fi

  if [ "$NODE_VERSION" != "$DESIRED_NODE_VERSION" ]; then
    echo "${red}${bold}Node${reset}${red} using $NODE_VERSION, but should be $DESIRED_NODE_VERSION"
  fi
}

ruby_status() {
  if ! [[ -f .ruby-version ]]; then
    return
  fi

  RUBY_VERSION=${RUBY_VERSION:-system}

  if ! echo $RUBY_VERSION | grep $(cat .ruby-version) > /dev/null; then
    echo -n "${red}${bold}Ruby${reset}${red} using $RUBY_VERSION, but should be " &&
    cat .ruby-version
  fi
}

in_git_repo() {
  dir=${1:-.}
  count=`expr 0$2 + 1`

  if [[ $count == "4" ]]; then return 1; fi
  if [[ -d $dir/.git ]]; then return 0; fi

  in_git_repo $dir/.. $count
}

git_status() {
  if ! (in_git_repo && [[ `history 1` != *'git status'* ]]); then
    return
  fi

  local status=$(git -c color.status=always status --branch --no-ahead-behind --short --untracked=normal . | sed -E 's/\.{3}[^ ]*$//g')
  local status_size=$(expr $(echo "$status" | grep -v "^\#\#" | wc -c))

  echo -n ${dark_gray}

  if [[ $status_size -gt $(tput cols) ]]; then
    echo "$status" | head -n 1
    local changed_files=$(expr $(echo "$status" | wc -l) - 1)
    echo $red"$changed_files files changed"
  else
    echo -n "$status" | tr '\n' '|' | sed -E 's/\|/\'$'\n/' | tr '|' ' ' | tr -s '\n '
    echo
  fi
}

use_status() {
  if [[ $USE != "" ]]; then
    echo -e "${yellow}$USE"
  fi
}

timer_start() {
  if [[ $BASH_COMMAND != "prompt_command" ]]; then
    timer_hash=$(echo "$BASH_COMMAND" | md5sum | cut -f 1 -d " ")

    if [[ -f /tmp/timer.$timer_hash ]]; then
      last_timer=$(cat /tmp/timer.$timer_hash)
      echo "${yellow}Estimated completion time: $(display_duration ${last_timer})${reset}"
    fi
  fi

  timer=${timer:-$SECONDS}
}
trap 'timer_start' DEBUG

timer_status() {
  timer_seconds=$(($SECONDS - $timer))
  unset timer
  if [[ $timer_seconds -ge 5 ]]; then
    echo $timer_seconds > /tmp/timer.$timer_hash

    echo -n $yellow
    display_duration $timer_seconds
  fi
}

prompt_command() {
  timer_status
  node_status
  ruby_status
  use_status
  git_status

  set_ps1
}

conditionally_display_exit_code() {
  exit_code="$?"
  if [ "${exit_code}" != "0" ]; then
    echo -n "${bold}${red}${exit_code}${reset} "
  fi
}

set_ps1() {
  # If exit code is nonzero, output it in red with a space.
  PS1='$(conditionally_display_exit_code)'

  if [[ -z "$TMUX" && "$CODESPACES" ]]; then
    PS1+='\[${dark_gray}\]${GITHUB_REPOSITORY} '
  fi

  # Tilde and prompt symbol with random color.
  PS1+='\[${cyan}\]\W\[$(random_color)\]$ '

  # Reset colors.
  PS1+='\[${reset}\]'
}

set_ps1

PROMPT_COMMAND='prompt_command'
