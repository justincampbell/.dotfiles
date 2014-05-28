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

ruby_status() {
  if ! [[ -f .ruby-version ]]; then
    return
  fi

  RUBY_VERSION=${RUBY_VERSION:-system}

  if ! grep -e $RUBY_VERSION .ruby-version > /dev/null; then
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
  in_git_repo &&
  [[ `history 1` != *'git status'* ]] &&
  echo -n ${dark_gray} &&
  git -c color.status=always status --branch --short --untracked=normal . |
  sed -E 's/\.{3}[^ ]*$//g' | tr '\n' '|' | sed -e 's/\|/\'$'\n/' | tr '|' ' ' | tr -s '\n '
}

use_status() {
  if [[ $USE != "" ]]; then
    echo -e "${yellow}$USE"
  fi
}

prompt_command() {
  (dotmusic &)

  ruby_status
  use_status
  git_status

  set_ps1
}

set_ps1() {
  PS1='\[\033]0;\W\]\[${red}\]${?##0} \[${cyan}\]\W\[$(random_color)\]$ \[${reset}\]'
}

set_ps1

PROMPT_COMMAND='prompt_command'
