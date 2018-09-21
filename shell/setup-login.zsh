# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive login
## ZSH sessions.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_LOGIN_ZSH" ] && return || readonly DOT_SETUP_LOGIN_ZSH=1


# Run setup-login.zsh in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run in each module
            if [ -f "$i/shell/setup-login.zsh" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup-login.zsh"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi
