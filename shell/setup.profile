# -*- mode: sh -*-
## ----------------------------------------------------------
## This file is executed for login shells only
## Must be compatible with ash/dash.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_PROFILE" ] && return || readonly DOT_SETUP_PROFILE=1

# Run setup.profile in all modules
if [ -d $DOT_DIR/modules ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d $i ]
        then
            # Set PATH to all module internal binary folders
            PATH="$i/bin:$PATH"
            # Run the setup.profile in each module
            if [ -f "$i/shell/setup.profile" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.profile"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Run setup.sh if not yet run
. "$DOT_DIR/shell/setup.sh"

# Run setup.bash if running bash
if [ -n "$BASH_VERSION" ]
then
    . "$DOT_DIR/shell/setup.bash"
fi
