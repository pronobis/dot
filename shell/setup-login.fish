# -*- mode: fish -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive login
## Fish sessions.
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_SETUP_LOGIN_FISH" ]
    set -g DOT_SETUP_LOGIN_FISH 1


# Add binary dir to PATH
__dot_add_path PATH "$DOT_DIR/bin"

# Run setup-login.all/setup.profile in all modules if login shell
if [ -d "$DOT_DIR/modules" ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i" ]
            # Add all module internal binary dirs to path
            __dot_add_path PATH "$i/bin"
            # Run in each module
            if [ -f "$i/shell/setup-login.all" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup-login.all"
                set -e DOT_MODULE_DIR
            end
            # setup.profile is deprecated and will be removed in the future
            if [ -f "$i/shell/setup.profile" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup.profile"
                set -e DOT_MODULE_DIR
            end
        end
    end
end

# Run setup-login.fish in all modules
if [ -d $DOT_DIR/modules ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i" ]
            # Run in each module
            if [ -f "$i/shell/setup-login.fish" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup-login.fish"
                set -e DOT_MODULE_DIR
            end
        end
    end
end


# Include guard
end
