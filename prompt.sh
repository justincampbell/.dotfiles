#!/bin/bash

orange=`tput setaf 166`
cyan=`tput setaf 6`
dark_gray=`tput setaf 236`
reset=`tput sgr0`

random_color() {
  echo -n `jot -r 1 1 231 | xargs tput setaf`
}

prompt_command() {
  set_ps1

  [[ -d .git ]] &&
  [[ `history 1` != *'git status'* ]] &&
  echo -n ${dark_gray} &&
  git status --branch --short --untracked=normal
}

set_ps1() {
  PS1='\[${cyan}\]\W\[${orange}\]\[$(random_color)\]$ \[${reset}\]'
}

set_ps1

PROMPT_COMMAND='prompt_command'
