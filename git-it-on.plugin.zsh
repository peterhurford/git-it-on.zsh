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
  if [ "$#" -eq 2 ]; then branch="$2"; fi
  local file=$(echo "$(cd $1; pwd)" | cut -c "$((1+${#$(git rev-parse --show-toplevel)}))-")
  url="$url/blob/$branch$file"
  open $url
}
git_open_repo() {
  shift
  git_set_repo
  if [ "$#" -eq 2 ]; then
    open "http://www.github.com/$1/$2"   
  elif [ "$#" -eq 0 ]; then
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
  if [ "$#" -eq 0 ]; then git_open_repo "repo"
  else; open "$url/tree/$1"; fi
}
git_open_pulls() {
  git_set_repo
  shift
  if [ "$#" -eq 0 ]; then open "$url/pulls"
  elif [ $1 -ge 0 2>/dev/null ]; then open "$url/pull/$1"
  else; open "$url/pulls?q=$@"; fi
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
git_ctrlp() {
  git_set_repo
  if [ "$#" -eq 0 ]; then branch="master"
  else; branch=$1; fi
  open "$url/find/$branch"
}
gitit() {
  if [ $1 = "repo" ]; then git_open_repo $@
  elif [ $1 = "compare" ]; then git_open_compare $2
  elif [ $1 = "commits" ]; then git_open_commits $2
  elif [ $1 = "file" ]; then git_open_file $2 $3
  elif [ $1 = "history" ]; then git_open_history $2 $3
  elif [ $1 = "branch" ]; then git_open_branch $2
  elif [ $1 = "pulls" ]; then git_open_pulls $@
  elif [ $1 = "grep" ]; then git_grep $@
  elif [ $1 = "ctrlp" ]; then git_ctrlp $2
  fi
}
