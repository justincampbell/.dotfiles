#!/bin/bash

cyan=`tput setaf 6`
red=`tput setaf 1`
dark_gray=`tput setaf 241`
reset=`tput sgr0`

random_color() {
  echo -n `jot -r 1 1 231 | xargs tput setaf`
}

prompt_command() {
  [[ -d .git ]] &&
  [[ `history 1` != *'git status'* ]] &&
  echo -n ${dark_gray} &&
  git status --branch --short --untracked=normal

  set_ps1
}

set_ps1() {
  PS1='\[${red}\]${?##0} \[${cyan}\]\W\[$(random_color)\]$ \[${reset}\]'
}

set_ps1

PROMPT_COMMAND='prompt_command'
