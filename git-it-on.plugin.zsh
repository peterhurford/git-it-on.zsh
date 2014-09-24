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
