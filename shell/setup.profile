# -*- mode: sh -*-
## --------------------------------------------
## This file is executed for login shells only
## Can be executed with dash
## --------------------------------------------

# Set path to the root .dot dir
export DOT_DIR="$HOME/.dot"

# Set PATH to the internal binary folder
export PATH="$DOT_DIR/bin:$PATH"

# Initialize all modules
if [ -d $DOT_DIR/modules ]; then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d $i ]
        then
            # Set PATH to all module internal binary folders
            PATH="$i/bin:$PATH"
            # Run the setup.profile in each module
            if [ -f "$i/setup.profile" ]
            then
                . "$i/setup.profile"
            fi
        fi
    done
    unset i
fi
