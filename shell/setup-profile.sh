# -*- mode: sh -*-
## ----------------------------------------------------------
## Sourced in $HOME/.profile and $HOME/.zprofile
## Executed for interactive and non-interactive login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_PROFILE_SH" ] && return || readonly DOT_SETUP_PROFILE_SH=1

# Make shell tools available
. "$DOT_DIR/shell/tools-shell.sh"


# Run setup-login.sh
. "$DOT_DIR/shell/setup-login.sh"

# Continue to setup-rc.sh
. "$DOT_DIR/shell/setup-rc.sh"
