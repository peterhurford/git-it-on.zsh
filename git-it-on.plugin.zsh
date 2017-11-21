#!/bin/zsh
__open() {
  if [ "$(uname -s)" = "Darwin" ]; then
    open "$1" 2> /dev/null
  else
    xdg-open "$1" &> /dev/null
  fi
}

__set_remote_branch() {
    branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)
    if [ $? -eq 0 ]; then
        branch="${branch/origin\//}"
    else
        false
    fi
}
__set_local_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD)
}

git_set_repo() {
  repo_url=$(git config --get remote.origin.url)
  if ! __set_remote_branch; then __set_local_branch; fi
  url="${repo_url/git/https}"
  url="${url/httpshub/github}"
  url="${url/.git/}"
  url="${url/https@/https://}"
  url="${url/com:/com/}"
  url="${url/ssh:\/\/}"
}


git_open_file() {
  file_path="$1"
  git_set_repo
  if [ ! -f $file_path ] && [ ! -d $file_path ]; then
    echo "$file_path does not exist"; echo ""; git_help
    return
  fi

  if [ "$#" -eq 2 ]; then branch="$2"; fi
  if [ -d $1 ]; then
    local cdtohere=$1
    local zone='tree'
  else
    local cdtohere="."
    local zone='blob'
  fi

  local file=$(echo "$(cd $cdtohere; pwd)" | cut -c "$((1+${#$(git rev-parse --show-toplevel)}))-")
  url="$url/$zone/$branch$file"

  if [ -d $1 ]; then
    url=$url
  else
    url="$url/$1"
  fi

  __open $url
}


git_open_compare() {
  git_set_repo
  if [ "$#" -ne 0 ]; then
    branch="$1"
  fi
  __open "$url/compare/$branch"
}


git_open_commits() {
  git_set_repo
  if [ "$#" -ne 0 ]; then
    branch="$1"
  fi
  __open "$url/commits/$branch"
}


git_open_history() {
  file_name="$1"
  git_set_repo
  if [ "$#" -eq 2 ]; then
    branch="$2"
  fi
  __open "$url/commits/$branch/$file_name"
}


git_open_branch() {
  branch_name="$1"
  git_set_repo
  if [ "$#" -eq 0 ]; then
    git_open_file
  else
    __open "$url/tree/$branch_name"
  fi
}


git_branches() {
  git_set_repo
  if [ "$#" -eq 0 ]; then
    local loc="active"
  elif [ "$1" = "mine" ]; then
    local loc="yours"
  else
    local loc=$1  # active, stale, all
  fi
  __open "$url/branches/$loc"
}


git_open_pulls() {
  git_set_repo
  shift
  if [ "$#" -eq 0 ]; then
    __open "$url/pulls"
  elif [ $1 -ge 0 2>/dev/null ]; then
    __open "$url/pull/$1"
  else
    __open "$url/pulls?q=$@"
  fi
}

git_open_issues() {
  git_set_repo
  shift
  if [ "$#" -eq 0 ]; then
    __open "$url/issues"
  elif [ $1 -ge 0 2>/dev/null ]; then
    __open "$url/issues/$1"
  else
    __open "$url/issues?q=$@"
  fi
}

git_grep() {
  git_set_repo
  if [[ "${2}" == "${2% *}" ]]; then
    shift
    url="$url/search?q=$@"
  else
    url="$url/search?q=\"$2\""
  fi
  __open $url
}


git_ctrlp() {
  git_set_repo
  if [ "$#" -eq 0 ]; then
    branch="master"
  else
    branch=$1
  fi
  __open "$url/find/$branch"
}


git_open_repo() {
  if [ "$#" -eq 2 ]; then
    username="$1"
    reponame="$2"
    __open "http://www.github.com/$username/$reponame"
  else
    git_open_file $1
  fi
}


git_help() {
  echo 'GIT IT ON'
  echo '============='
  echo '* `gitit` -- open your current folder, on your current branch, in GitHub.'
  echo '* `gitit <folder or file>` -- open that folder in your current branch (paths are relative).'
  echo '* For more, visit https://github.com/peterhurford/git-it-on.zsh or type `gitit repo peterhurford git-it-on.zsh`'
  echo ''
  echo 'Available first arguments: compare, commits, history, branch, branches, pulls, issues, grep, ctrlp, repo, help'
}


gitit() {
  gitit_command="$1"
  if [ $# -eq 0 ]; then git_open_file
  elif [ $gitit_command = "compare" ]; then git_open_compare $2
  elif [ $gitit_command = "commits" ]; then git_open_commits $2
  elif [ $gitit_command = "history" ]; then git_open_history $2 $3
  elif [ $gitit_command = "branch" ]; then git_open_branch $2
  elif [ $gitit_command = "branches" ]; then git_branches $2
  elif [ $gitit_command = "pulls" ]; then git_open_pulls $@
  elif [ $gitit_command = "issues" ]; then git_open_issues $@
  elif [ $gitit_command = "grep" ]; then git_grep $@
  elif [ $gitit_command = "ctrlp" ]; then git_ctrlp $2
  elif [ $gitit_command = "repo" ]; then git_open_repo $2 $3
  elif [ $gitit_command = "help" ]; then git_help
  else git_open_file $1 $2
  fi
}
