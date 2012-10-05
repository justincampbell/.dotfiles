#!/bin/sh

if [[ $(git branch --no-color | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/') != 'master' ]]; then
  echo "Need to be on master"
  return 1
fi

delete_merged_branches() {
  git for-each-ref --format='%(refname)' refs/heads | while read branch; do
    git rev-parse --quiet --verify "$branch" > /dev/null || continue 
    git symbolic-ref HEAD "$branch"
    git branch -d $( git branch --merged | grep -v '^\*' | grep -v 'master' )
  done
}

print_branch_count() {
  echo "$(git branch | wc -l | tr -d ' ') branches"
}

print_branch_count
delete_merged_branches
print_branch_count
git checkout master

