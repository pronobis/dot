# -*- mode: sh -*-
## ----------------------------------------------------------
## This file is executed for both login and non-login shells.
## It is used only if the shell is bash.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_BASH" ] && return || readonly DOT_SETUP_BASH=1

# Run setup.sh if not yet run
. "$DOT_DIR/shell/setup.sh"

# Run setup.bash in all modules
if [ -d $DOT_DIR/modules ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d $i ]
        then
            # Run the setup.sh in each module
            if [ -f "$i/shell/setup.bash" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.bash"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Setup selected system
if [ -d "$DOT_DIR/system" ] && [ -f "$DOT_DIR/system/setup.bash" ]
then
   . "$DOT_DIR/system/setup.bash"
fi

# Functions for accessing the sys and cmd commands
sys()
{
    $DOT_DIR/scripts/sys $@
    if [ -d "$DOT_DIR/system" ]
    then
        . "$DOT_DIR/system/setup.bash"
    fi
}
cmd()
{
    $DOT_DIR/scripts/cmd $@
    if [ -d "$DOT_DIR/system" ]
    then
        . "$DOT_DIR/system/setup.bash"
    fi
}
