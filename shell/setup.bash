# -*- mode: sh -*-
## --------------------------------------------
## This file is executed for all bash sessions
## --------------------------------------------

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
        DOT_MODULE_DIR="$i"
        . "$i/shell/setup.bash"
        unset DOT_MODULE_DIR
    fi
done
unset DOT_MODULES

# Setup selected system
if [ -d "$DOT_DIR/system" ]
then
    . "$DOT_DIR/system/setup.bash"
fi

# Functions for accessing the sys and cmd commands
function sys
{
    $DOT_DIR/scripts/sys
    if [ -d "$DOT_DIR/system" ]
    then
        . "$DOT_DIR/system/setup.bash"
    fi
}
function cmd
{
    $DOT_DIR/scripts/cmd
    if [ -d "$DOT_DIR/system" ]
    then
        . "$DOT_DIR/system/setup.bash"
    fi
}
