function dotIt() {
  if which 'dot' > /dev/null; then
    local dotPath=$1
    dotOutPutPath=/tmp/${dotPath}.png
    dot -Tpng -o $dotOutPutPath $dotPath
    open $dotOutPutPath
  else
    echo "Not not on the path"
  fi
}
