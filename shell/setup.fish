# -*- mode: fish -*-
## ----------------------------------------------------------
## Executed for interactive and non-interactive
## login and non-login Fish sessions.
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_SETUP_FISH" ]
set -g DOT_SETUP_FISH 1


# Run setup.all in all modules
if [ -d $DOT_DIR/modules ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i" ]
            # Run in each module
            if [ -f "$i/shell/setup.all" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup.all"
                set -e DOT_MODULE_DIR
            end
        end
    end
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


# Include guard
end
