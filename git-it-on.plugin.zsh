git_set_repo() {
  repo_url=`git config --get remote.origin.url`
  branch=`git rev-parse --abbrev-ref HEAD`
  url="${repo_url/git/http}"
  url="${url/httphub/github}"
  url="${url/.git//}"
  url="${url/http@/http://}"
  url="${url/com:/com/}"
}
git_open_file() {
  git_set_repo
  echo $#
  url="$url/blob/$branch/$1"
  open $url
}
git_open_repo() {
  if [ "$#" -ne 1 ]; then
    git_set_repo
    open "$url/tree/$branch"
  else
    git_open_file $1
  fi
}
git_open_compare() {
  git_set_repo
  open "$url/compare/$branch"
}
git_open_commits() {
  git_set_repo
  open "$url/commits/$branch"
}
git_open_history() {
  git_set_repo
  url="$url/commits/$branch/$1"
  open $url
}
git_grep() {
  git_set_repo
  if [[ "${2}" == "${2% *}" ]] ; then
    shift
    url="$url/search?q=$@"
  else
    url="$url/search?q=\"$2\""
  fi
  open $url
}
gitit() {
  if [ $1 = "repo" ]; then git_open_repo $2
  elif [ $1 = "compare" ]; then git_open_compare
  elif [ $1 = "commits" ]; then git_open_commits
  elif [ $1 = "file" ]; then git_open_file $2
  elif [ $1 = "history" ]; then git_open_history $2
  elif [ $1 = "grep" ]; then git_grep $@
  fi
}
#TODO: Can open a file even if not in the root repo
#TODO: Git open arbitrary branch
