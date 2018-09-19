# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_LOGIN_SH" ] && return || readonly DOT_SETUP_LOGIN_SH=1

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
