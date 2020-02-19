# -*- mode: sh -*-
## ----------------------------------------------------------
## Sourced in $HOME/.bashrc and $HOME/.zshrc
## Executed for interactive login and non-login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_RC_SH" ] && return || readonly DOT_SETUP_RC_SH=1

# Make shell tools available
. "$DOT_DIR/shell/tools-shell.sh"

# Load module parameters
__dot_load_params

# Run setup-login.sh/bash if running bash login session and non yet run
# This is needed if .profile sources .bashrc before setup-profile.sh
if [ -n "$BASH_VERSION" ]
then
    if shopt -q login_shell
    then
        . "$DOT_DIR/shell/setup-login.sh"
        . "$DOT_DIR/shell/setup-login.bash"
    fi
fi

# Run setup-login.sh/zsh if running zsh login session and non yet run
# This is needed if .zprofile sources .zshrc before setup-profile.sh
if [ -n "$ZSH_VERSION" ]
then
    if [[ -o login ]]
    then
        . "$DOT_DIR/shell/setup-login.sh"
        . "$DOT_DIR/shell/setup-login.zsh"
    fi
fi

# Run setup.sh
. "$DOT_DIR/shell/setup.sh"

# Run setup.bash
if [ -n "$BASH_VERSION" ]
then
    . "$DOT_DIR/shell/setup.bash"
fi

# Run setup.zsh
if [ -n "$ZSH_VERSION" ]
then
    . "$DOT_DIR/shell/setup.zsh"
fi

# Run scripts for interactive shells
if [ "${-#*i*}" != "$-" ]
then
    # Run setup-interactive.sh
    . "$DOT_DIR/shell/setup-interactive.sh"

    # Run setup-interactive.bash
    if [ -n "$BASH_VERSION" ]
    then
        . "$DOT_DIR/shell/setup-interactive.bash"
    fi

    # Run setup-interactive.zsh
    if [ -n "$ZSH_VERSION" ]
    then
        . "$DOT_DIR/shell/setup-interactive.zsh"
    fi
fi
