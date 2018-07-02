
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi


# Try work out the current directory
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Any local bin folders go on the path
export PATH=$HOME/.bin:$HOME/bin:$PATH

source $SCRIPTS_DIR/gitHelpers.bash
source $SCRIPTS_DIR/osXHelpers.bash
source $SCRIPTS_DIR/gitPrompt.bash

# Reload the bash env
alias r="source ~/.bash_profile"

#Editor for things like git commits
export EDITOR='vim'

# Send a notification to growl
growl() { echo -e $'\e]9;'${1}'\007' ; return ; }


export CDPATH=$HOME/stripe:$HOME/github



#Share bash history across shells
export PROMPT_COMMAND='history -a'

#Get cargo on the path for rust things
export PATH=$PATH:~/.cargo/bin
