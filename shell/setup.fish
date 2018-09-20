# -*- mode: fish -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive,
## login and non-login Fish sessions.
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_SETUP_FISH" ]
set -g DOT_SETUP_FISH 1


# Make shell tools available
source "$DOT_DIR/shell/tools-shell.fish"

# Handle common login shell setup
if status is-login
    # Add binary dir to PATH
    __dot_add_path PATH "$DOT_DIR/bin"

    # Run setup.profile in all modules if login shell
    if [ -d "$DOT_DIR/modules" ]
        for i in (ls "$DOT_DIR/modules" | sort)
            set -l i "$DOT_DIR/modules/$i"
            if [ -d "$i" ]
                # Add all module internal binary dirs to path
                __dot_add_path PATH "$i/bin"
                # Run in each module
                if [ -f "$i/shell/setup.profile" ]
                    set -g DOT_MODULE_DIR "$i"
                    source "$i/shell/setup.profile"
                    set -e DOT_MODULE_DIR
                end
            end
        end
    end

    # Run setup-login.fish in all modules
    source "$DOT_DIR/shell/setup-login.fish"
end

# Run setup.fish in all modules
if [ -d $DOT_DIR/modules ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i" ]
            # Run in each module
            if [ -f "$i/shell/setup.fish" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup.fish"
                set -e DOT_MODULE_DIR
            end
        end
    end
end

# Run setup-interactive.fish in all modules if interactive shell
if status is-interactive
    source "$DOT_DIR/shell/setup-interactive.fish"
end


# Include guard
end
