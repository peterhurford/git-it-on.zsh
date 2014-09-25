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
  if [ "$#" -eq 2 ]; then branch="$2"; fi
  if [[ "${1%.*}" == "." ]]; then
    repo_name=${repo_url#*/}
    repo_name=${repo_name%.*} 
    if [ "$1" == "." ]; then
      dot_is_this=$PWD
    else
      dot_is_this="$PWD/$1"
    fi
    while [ "${dot_is_this%%/*}" != "$repo_name" ]; do
      dot_is_this=${dot_is_this#*/}
    done
    dot_is_this="${dot_is_this/$repo_name/}"
    echo $dot_is_this
    url="$url/blob/$branch/$dot_is_this"
    open $url
  else
    url="$url/blob/$branch/$1"
    echo $url
    open $url
  fi
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
  if [ "$#" -ne 0 ]; then; branch="$1"; fi
  open "$url/compare/$branch"
}
git_open_commits() {
  git_set_repo
  if [ "$#" -ne 0 ]; then; branch="$1"; fi
  open "$url/commits/$branch"
}
git_open_history() {
  git_set_repo
  if [ "$#" -eq 2 ]; then branch="$2"; fi
  open "$url/commits/$branch/$1"
}
git_open_branch() {
  git_set_repo
  open "$url/tree/$1"
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
  elif [ $1 = "compare" ]; then git_open_compare $2
  elif [ $1 = "commits" ]; then git_open_commits $2
  elif [ $1 = "file" ]; then git_open_file $2 $3
  elif [ $1 = "history" ]; then git_open_history $2 $3
  elif [ $1 = "branch" ]; then git_open_branch $2
  elif [ $1 = "grep" ]; then git_grep $@
  fi
}
#TODO: Gitit file works with relative paths.
#TODO: Gitit repo is relative to the current folder by default.
#TODO: Gitit file is relative to the current folder by default.
#TODO: Complains about missing arguments.
#TODO: Help on entering 'gitit' with no arguments or on entering 'gitit help'
#TODO: Man page
#TODO: Tab completion
