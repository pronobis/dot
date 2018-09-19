# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive,
## login and non-login Bash sessions.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_BASH" ] && return || readonly DOT_SETUP_BASH=1


# Run setup.profile if not yet run and in login shell
if shopt -q login_shell
then
    . "$DOT_DIR/shell/setup.profile"
fi

# Run setup.sh if not yet run
. "$DOT_DIR/shell/setup.sh"

# Run setup.bash in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run in each module
            if [ -f "$i/shell/setup.bash" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup.bash"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Run setup-interactive.bash if not yet run and in interactive shell
if [ "${-#*i*}" != "$-" ]
then
    . "$DOT_DIR/shell/setup-interactive.bash"
fi
