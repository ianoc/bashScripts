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


alias gs="git status"


# push current branch only by default
git config --global push.default current # Do it often, but its cheap.. and means will setup new machines/shells easier

#Updates the local master and then rebase this branch onto it
grbom() {
  echo "Updating local master, then rebasing current branch onto master"
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  git checkout master && git pull && git checkout $BRANCH_NAME && git rebase master
}

gmom() {
  echo "Updating local master, then merging master onto current branch"
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  git checkout master && git pull && git checkout $BRANCH_NAME && git merge master
}

function gbl() {
git branch --sort=-committerdate
}