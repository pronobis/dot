# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive, login and non-login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_INTERACTIVE_SH" ] && return || readonly DOT_SETUP_INTERACTIVE_SH=1


# Run setup-interactive.sh in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run in each module
            if [ -f "$i/shell/setup-interactive.sh" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup-interactive.sh"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Setup selected system
if [ -d "$DOT_DIR/system" ] && [ -f "$DOT_DIR/system/setup.sh" ]
then
    . "$DOT_DIR/system/setup.sh"
fi

# Functions for accessing the sys and cmd commands
sys()
{
    $DOT_DIR/scripts/sys $@
    if [ -d "$DOT_DIR/system" ]
    then
        [ -f "$DOT_DIR/system/setup.sh" ] && . "$DOT_DIR/system/setup.sh"
        [ -n "$BASH_VERSION" ] && [ -f "$DOT_DIR/system/setup.bash" ] && . "$DOT_DIR/system/setup.bash"
    fi
}
cmd()
{
    $DOT_DIR/scripts/cmd $@
    if [ -d "$DOT_DIR/system" ]
    then
        [ -f "$DOT_DIR/system/setup.sh" ] && . "$DOT_DIR/system/setup.sh"
        [ -n "$BASH_VERSION" ] && [ -f "$DOT_DIR/system/setup.bash" ] && . "$DOT_DIR/system/setup.bash"
    fi
}
