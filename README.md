bashScripts
===========


1. goProjects.bash

This is a helper tool to make it easy to jump around on the shell via bash. Its designed for favorites + auto-complete support to move between a range of interested in folders.

Right now the default is to support two folder tree's. One we wild card in (in my case my github repos i've checked out), and in another that we have picked specific sub directories to work with.

Using it would be as simple as adding to your .bashrc
```bash
# All sub directories to this folder will be included for auto-complete, go
export WILD_CARD_PATH="${HOME}/workspace/github"
# The specific folders live in here
export SPECIFIC_PATH_BASE="${HOME}/workspace"
# Space separated list of valid paths to jump to
export SPECIFIC_SUB_PATHS="github"

source ~/path_to_goProjects.bash
```

after that, 

```g gi<tab> should -> g github enter will cd to that folder```

```g gi<enter> -> cd to that folder```

Tabbing is mostly useful when you have competeing prefixes and you want to know which one you will goto.

(go is the same as g, one is an alias to the other)




