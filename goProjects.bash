#All files/folders in this path will be offered for auto-complete
if [ -z "$WILD_CARD_PATH" ]; then
  WILD_CARD_PATH="${HOME}/workspace/github"
fi

#Root of a path where we supply a list of valid directories
if [ -z "$SPECIFIC_PATH_BASE" ]; then
  SPECIFIC_PATH_BASE="${HOME}/workspace"
fi

#Space separated list of valid sub directories
if [ -z "$SPECIFIC_SUB_PATHS" ]; then
  SPECIFIC_SUB_PATHS="github"
fi

function go {
  local targets=""
  for d in $SPECIFIC_SUB_PATHS; do
    local targets="$targets $d,${SPECIFIC_PATH_BASE}/$d"
  done

  for d in `ls ${WILD_CARD_PATH}`; do
    local targets="$targets $d,${WILD_CARD_PATH}/$d"
  done

  local target=$1
  local IFS=" "
  if [ -z "$target" ]; then return; fi
  for i in $targets; do
    local IFS=",";
    set $i;
    compare_against=$1
    current_target_path=$2
    match_test=`echo ${compare_against},,,,${target} | awk -F,,,, 'match($1,$2){print RSTART}'`
    if [ "$match_test" == "1" ]; then
      cd $current_target_path
      return
    fi
  done
}

function goCompletes
{
  local cur
  cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=()   # Array variable storing the possible completions.
  local targets=""
  for d in $SPECIFIC_SUB_PATHS; do
      local targets="$targets $d"
  done
  for d in `ls ${WILD_CARD_PATH}`; do
      local targets="$targets $d"
  done

  COMPREPLY=( $( compgen -W "$targets" -- $cur ) )
  return 0
}

alias g=go
complete -F goCompletes go
complete -F goCompletes g