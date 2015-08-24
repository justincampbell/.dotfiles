#!/bin/bash

cyan=`tput setaf 6`
red=`tput setaf 1`
yellow=`tput setaf 3`
dark_gray=`tput setaf 241`
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
  blacklist=("0" "8" "16" "17" "18" "59")

  until $(! contains "${blacklist[@]}" "$random_color"); do
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

ruby_status() {
  if ! [[ -f .ruby-version ]]; then
    return
  fi

  RUBY_VERSION=${RUBY_VERSION:-system}

  if ! echo $RUBY_VERSION | grep $(cat .ruby-version) > /dev/null; then
    echo -n "${red}Ruby using $RUBY_VERSION, but should be " &&
    cat .ruby-version
  fi
}

in_git_repo() {
  dir=${1:-.}
  count=`expr 0$2 + 1`

  if [[ $count == "10" ]]; then return 1; fi
  if [[ -d $dir/.git ]]; then return 0; fi

  in_git_repo $dir/.. $count
}

git_status() {
  if !(in_git_repo && [[ `history 1` != *'git status'* ]]); then
    return
  fi

  local status=$(git -c color.status=always status --branch --short --untracked=normal . | sed -E 's/\.{3}[^ ]*$//g')
  local status_size=$(expr $(echo "$status" | grep -v "^\#\#" | wc -c))

  echo -n ${dark_gray}

  if [[ $status_size -gt $(tput cols) ]]; then
    echo "$status" | head -n 1
    local changed_files=$(expr $(echo "$status" | wc -l) - 1)
    echo $red"$changed_files files changed"
  else
    echo "$status" | tr '\n' '|' | sed -e 's/\|/\'$'\n/' | tr '|' ' ' | tr -s '\n '
  fi
}

use_status() {
  if [[ $USE != "" ]]; then
    echo -e "${yellow}$USE"
  fi
}

timer_start() {
  timer=${timer:-$SECONDS}
}
trap 'timer_start' DEBUG

timer_status() {
  timer_seconds=$(($SECONDS - $timer))
  unset timer
  if [[ $timer_seconds -ge 5 ]]; then
    echo -n $yellow
    display_duration $timer_seconds
  fi
}

prompt_command() {
  (dotmusic &)

  timer_status
  ruby_status
  use_status
  git_status

  set_ps1
}

set_ps1() {
  PS1='\[\033]0;\W\]\n\[${red}\]${?##0} \[${cyan}\]\W\[$(random_color)\]$ \[${reset}\]'
}

set_ps1

PROMPT_COMMAND='prompt_command'
