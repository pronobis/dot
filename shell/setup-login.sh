# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_LOGIN_SH" ] && return || readonly DOT_SETUP_LOGIN_SH=1


# Add binary dir to PATH
__dot_add_path PATH "$DOT_DIR/bin"

# Run setup-login.all/setup.profile in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Add all module internal binary dirs to path
            __dot_add_path PATH "$i/bin"
            # Run in each module
            if [ -f "$i/shell/setup-login.all" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup-login.all"
                unset DOT_MODULE_DIR
            fi
            # setup.profile is deprecated and will be removed in the future
            if [ -f "$i/shell/setup.profile" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.profile"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Run setup-login.sh in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run in each module
            if [ -f "$i/shell/setup-login.sh" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup-login.sh"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi
