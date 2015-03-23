#!/bin/zsh
__open() {
  if [ "$(uname -s)" = "Darwin" ]; then
    open "$1" 2> /dev/null
  else
    xdg-open "$1" &> /dev/null
  fi
}
git_set_repo() {
  repo_url=$(git config --get remote.origin.url)
  branch=$(git rev-parse --abbrev-ref HEAD)
  url="${repo_url/git/http}"
  url="${url/httphub/github}"
  url="${url/.git//}"
  url="${url/http@/http://}"
  url="${url/com:/com/}"
  url="${url%/*}"
}
git_open_file() {
  git_set_repo
  if [ ! -f $1 ]; then
    echo "$1 does not exist"; echo ""; git_help
    return
  fi
  if [ "$#" -eq 2 ]; then branch="$2"; fi
  if [ -d $1 ]; then; local cdtohere=$1; local zone='tree'; else; local cdtohere="."; local zone='blob'; fi
  local file=$(echo "$(cd $cdtohere; pwd)" | cut -c "$((1+${#$(git rev-parse --show-toplevel)}))-")
  url="$url/$zone/$branch$file"
  if [ -d $1 ]; then; url=$url; else; url="$url/$1"; fi
  __open $url
}
git_open_compare() {
  git_set_repo
  if [ "$#" -ne 0 ]; then; branch="$1"; fi
  __open "$url/compare/$branch"
}
git_open_commits() {
  git_set_repo
  if [ "$#" -ne 0 ]; then; branch="$1"; fi
  __open "$url/commits/$branch"
}
git_open_history() {
  git_set_repo
  if [ "$#" -eq 2 ]; then branch="$2"; fi
  __open "$url/commits/$branch/$1"
}
git_open_branch() {
  git_set_repo
  if [ "$#" -eq 0 ]; then git_open_file
  else; __open "$url/tree/$1"; fi
}
git_open_pulls() {
  git_set_repo
  shift
  if [ "$#" -eq 0 ]; then __open "$url/pulls"
  elif [ $1 -ge 0 2>/dev/null ]; then __open "$url/pull/$1"
  else; __open "$url/pulls?q=$@"; fi
}
git_grep() {
  git_set_repo
  if [[ "${2}" == "${2% *}" ]] ; then
    shift
    url="$url/search?q=$@"
  else
    url="$url/search?q=\"$2\""
  fi
  __open $url
}
git_ctrlp() {
  git_set_repo
  if [ "$#" -eq 0 ]; then branch="master"
  else; branch=$1; fi
  __open "$url/find/$branch"
}
git_open_repo() {
  if [ "$#" -eq 2 ]; then __open "http://www.github.com/$1/$2"
  else; git_open_file $1; fi
}
git_help() {
  echo 'GIT IT ON'
  echo '============='
  echo '* `gitit` -- open your current folder, on your current branch, in GitHub.'
  echo '* `gitit <folder or file>` -- open that folder in your current branch (paths are relative).'
  echo '* For more, visit https://github.com/peterhurford/git-it-on.zsh or type `gitit repo peterhurford git-it-on.zsh`'
}
gitit() {
  if [ $# -eq 0 ]; then git_open_file
  elif [ $1 = "compare" ]; then git_open_compare $2
  elif [ $1 = "commits" ]; then git_open_commits $2
  elif [ $1 = "history" ]; then git_open_history $2 $3
  elif [ $1 = "branch" ]; then git_open_branch $2
  elif [ $1 = "pulls" ]; then git_open_pulls $@
  elif [ $1 = "grep" ]; then git_grep $@
  elif [ $1 = "ctrlp" ]; then git_ctrlp $2
  elif [ $1 = "repo" ]; then git_open_repo $2 $3
  elif [ $1 = "help" ]; then git_help
  else git_open_file $1 $2
  fi
}
