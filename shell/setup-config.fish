# -*- mode: fish -*-
## ----------------------------------------------------------
## Sourced in $HOME/.config/fish/config.fish
## Executed for interactive and non-interactive,
## login and non-login Fish sessions.
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_SETUP_CONFIG_FISH" ]
set -g DOT_SETUP_CONFIG_FISH 1

# Make shell tools available
source "$DOT_DIR/shell/tools-shell.fish"


# Run setup-login.fish if login session
if status is-login
    source "$DOT_DIR/shell/setup-login.fish"
end

# Run setup.fish
source "$DOT_DIR/shell/setup.fish"

# Run setup-interactive.fish if interactive session
if status is-interactive
    source "$DOT_DIR/shell/setup-interactive.fish"
end


# Include guard
end
