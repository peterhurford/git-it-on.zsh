git_set_repo() {
  repo_url=`git config --get remote.origin.url`
  branch=`git rev-parse --abbrev-ref HEAD`
  url="${repo_url/git/http}"
  url="${url/httphub/github}"
  url="${url/.git//}"
  url="${url/http@/http://}"
  url="${url/com:/com/}"
}
git_open_repo() {
  git_set_repo
  open "$url/tree/$branch"
}
git_open_compare() {
  git_set_repo
  open "$url/compare/$branch"
}
git_open_file() {
  git_set_repo
  url="$url/blob/$branch/$1"
  open $url
}
git_open_history() {
  git_set_repo
  url="$url/commits/$branch/$1"
  open $url
}
git_grep() {
  git_set_repo
  url="$url/search?q=$1"
  open $url
}
gitit() {
  if [ $1 = "repo" ]; then git_open_repo
  elif [ $1 = "compare" ]; then git_open_compare
  elif [ $1 = "file" ]; then git_open_file $2
  elif [ $1 = "history" ]; then git_open_history $2
  elif [ $1 = "grep" ]; then git_grep $2
  fi
}
#TODO: Can open a file even if not in the root repo
#TODO: Git grep sends all arguments
#TODO: Git open arbitrary branch
