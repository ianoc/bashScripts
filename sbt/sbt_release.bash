sbt_do_release() {

  show_help() {
    echo "In help"
  }

  valid_sbt_folder() {
    if [ -e 'version.sbt' ] || [ -e 'project/Build.scala' ] ; then
      return 0
    else
      return 1
    fi
  }

  local SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  local PROJ_HOME=`pwd`
  local PROJ_NAME=`basename $PWD`

  SBT_RUNNER="./sbt"
  if [ ! -e 'sbt' ]; then
    echo "sbt file not present in using included runner."
    SBT_RUNNER="$SCRIPT_PATH/sbt"
  fi

  # Initialize our own variables:
  local_release=1
  verbose=0
  OVERRIDE_RESOLVER_CMD=""
  POST_PUSH_HOOK=""

  OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.
  while getopts "hrlo:p:" opt; do
    case "$opt" in
        h)
            show_help
            return 0
            ;;
        r)  local_release=0
            ;;
        l)  local_release=1
            ;;
        o)
          OVERRIDE_RESOLVER_CMD=$OPTARG
          ;;
        p)
          POST_PUSH_HOOK=$OPTARG
          ;;
        '?')
            show_help >&2
            return 1
            ;;
    esac
  done

  shift $((OPTIND-1)) # Shift off the options and optional --.
  valid_sbt_folder || (echo "invalid folder, doesn't look like an sbt project" && return -1)

  SBT_BUILD_FILE='project/Build.scala'

  SBT_VERSION_FILE=""
  SBT_VERSION_STRING=""
  INCLUDE_COMMA=""
  if [ -e 'version.sbt' ]
    then
      SBT_VERSION_FILE='version.sbt'
      SBT_VERSION_STRING="version in ThisBuild"
      INCLUDE_COMMA=""
    else
      SBT_VERSION_FILE=$SBT_BUILD_FILE
      SBT_VERSION_STRING="version"
      INCLUDE_COMMA=","
  fi

  if [ "`git diff $SBT_VERSION_FILE | wc -l`" -gt 0 ]
    then
      echo "Build file has local changes to $SBT_VERSION_FILE, cannot. Quitting."
      echo "==== PRINTING git status ===="
      git status
      return -1
  fi

  git checkout $SBT_VERSION_FILE

  GIT_HASH=`git log -n 1 | head -n 1 | awk '{print $2}'`
  TS=`python -c "import time; print(long(time.time())*1000L)"`
  OLD_VER=`cat $SBT_VERSION_FILE | grep "$SBT_VERSION_STRING :=" | sed -e 's/^[ A-Za-z:="]*\([0-9.]*\).*/\1/g'`
  NEW_BASE_VER=`echo $OLD_VER | awk -F. '{ print $1 "." $2 "." $3 + 1 }'`
  NEW_VER="$NEW_BASE_VER-t${TS}-${GIT_HASH}"

  if [ ! -z "$OVERRIDE_RESOLVER_CMD" ]; then
    if [ "`git diff $SBT_BUILD_FILE | wc -l`" -gt 0 ]; then
      echo "Build file has local changes to $SBT_BUILD_FILE, cannot. Quitting."
      echo "==== PRINTING git status ===="
      git status
      return -1
    fi

    eval "$OVERRIDE_RESOLVER_CMD $PROJ_HOME"
  fi

  sed -i "" -e "s/\s*$SBT_VERSION_STRING :=.*/$SBT_VERSION_STRING := \"$NEW_VER\"$INCLUDE_COMMA/g" $SBT_VERSION_FILE

  if [[ $local_release -eq 0 ]]
    then
      $SBT_RUNNER clean publish || return -1
      git checkout $SBT_VERSION_FILE || return -1
    else
      $SBT_RUNNER clean publishM2 publish-local || return -1
      git checkout $SBT_VERSION_FILE || return -1
  fi

  if [ ! -z "$POST_PUSH_HOOK" ];
    then
      eval "$POST_PUSH_HOOK $PROJ_HOME $PROJ_NAME $NEW_VER"
  fi
}
