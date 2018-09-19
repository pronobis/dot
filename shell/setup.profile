# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_PROFILE" ] && return || readonly DOT_SETUP_PROFILE=1


# Make shell tools available
. "$DOT_DIR/shell/tools-shell.sh"

# Add binary dir to PATH
PATH="$DOT_DIR/bin:$PATH"

# Run setup.profile in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Add all module internal binary dirs to path
            PATH="$i/bin:$PATH"
            # Run in each module
            if [ -f "$i/shell/setup.profile" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.profile"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Run setup-login.sh
. "$DOT_DIR/shell/setup-login.sh"

# Run setup-login.bash if running bash
if [ -n "$BASH_VERSION" ]
then
    . "$DOT_DIR/shell/setup-login.bash"
fi

# Run setup.sh if not yet run
. "$DOT_DIR/shell/setup.sh"

# Run setup.bash if running bash
if [ -n "$BASH_VERSION" ]
then
    . "$DOT_DIR/shell/setup.bash"
fi
