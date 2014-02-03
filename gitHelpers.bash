gitRefreshMaster() {
  if [ ! -d .git ]; then
    echo "Not a git folder"
    return
  fi

  local CUR_BRANCH=`git branch | egrep "^\* " | awk '{print $2}'`
  local NO_STASH=`git stash | grep "No local changes to save" | wc -l`

  git checkout master
  git pull
  git checkout $CUR_BRANCH
  git merge master -m "Updating to master"

  if [ $NO_STASH -eq "0" ]; then
    git stash pop
  fi
}

gitAddTrack() {
  CUR_BRANCH=`git branch | egrep "^\* " | awk '{print $2}'`
  git branch -u origin/$CUR_BRANCH
}

