# -*- mode: sh -*-
## --------------------------------------------
## This file is executed for all bash sessions
## --------------------------------------------

# Set path to the root .dot dir
export DOT_DIR="$HOME/.dot"

# Import tools
. $DOT_DIR/shell/tools.bash

# Sort the paths
IFS=$'\n' DOT_MODULES=($(sort <<<"${DOT_MODULES[*]}"))

# Setup modules
dot_get_modules
for i in ${DOT_MODULES[@]}
do
    # Run the setup.bash in each module
    if [ -f "$i/shell/setup.bash" ]
    then
        . "$i/shell/setup.bash"
    fi
done

# Setup selected system
if [ -d "$DOT_DIR/system" ]
then
    . "$DOT_DIR/system/setup.bash"
fi
