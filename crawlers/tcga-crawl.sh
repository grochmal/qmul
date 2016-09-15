#!/bin/sh

DIRS=0
FILES=0

crawl () {
  echo "crawl ($2) from: $1"
  local url=$1
  local dir=$2
  echo "mkdir -p $dir"
  mkdir -p $dir
  curl $url 2>/dev/null     |
  grep '<a'                 |
  grep -v '>Name<'          |
  grep -v '>Last modified<' |
  grep -v '>Size<'          |
  grep -v 'lost+found'      |
  grep -v images            |
  cut -d '"' -f 2           |
  while read x; do
    sleep 6
    echo "SEEN $FILES FILES and $DIRS DIRCTORIES"
    if [[ "$x" == "${x%/}" ]]; then
      # it's a file
      let FILES++
      echo "wget -O $dir$x $url$x"
      wget -O $dir$x $url$x
    else
      # it's a directory
      let DIRS++
      crawl $url$x $dir$x
    fi
  done
}

if [[ "x$1" == "x" ]]; then
  echo "Usage: crawl.sh <HTML index>"
  exit 0
fi

crawl $1 "tcga/"
echo "TOTAL: $FILES files and $DIRS directories"

