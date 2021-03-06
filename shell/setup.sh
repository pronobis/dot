# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive
## login and non-login sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_SH" ] && return || readonly DOT_SETUP_SH=1


# Run setup.all in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run in each module
            if [ -f "$i/shell/setup.all" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.all"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Run setup.sh in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run in each module
            if [ -f "$i/shell/setup.sh" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.sh"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi
