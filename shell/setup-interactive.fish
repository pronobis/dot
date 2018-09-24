# -*- mode: fish -*-
## ----------------------------------------------------------
## Executed for interactive, login and non-login
## Fish sessions.
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_SETUP_INTERACTIVE_FISH" ]
    set -g DOT_SETUP_INTERACTIVE_FISH 1


# Run setup-interactive.all in all modules
if [ -d "$DOT_DIR/modules" ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i" ]
            # Run in each module
            if [ -f "$i/shell/setup-interactive.all" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup-interactive.all"
                set -e DOT_MODULE_DIR
            end
        end
    end
end

# Run setup-interactive.fish in all modules
if [ -d "$DOT_DIR/modules" ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i" ]
            # Run in each module
            if [ -f "$i/shell/setup-interactive.fish" ]
                set -g DOT_MODULE_DIR "$i"
                source "$i/shell/setup-interactive.fish"
                set -e DOT_MODULE_DIR
            end
        end
    end
end

# Setup selected system
if [ -d "$DOT_DIR/system" ]
    [ -f "$DOT_DIR/system/setup.all" ]; and source "$DOT_DIR/system/setup.all"
    [ -f "$DOT_DIR/system/setup.fish" ]; and source "$DOT_DIR/system/setup.fish"
end

# Add paths to fish_complete_path and fish_function_path
set fish_function_path "$DOT_DIR/shell/fish/functions" $fish_function_path
set fish_complete_path "$DOT_DIR/shell/fish/completions" $fish_complete_path

# Add paths to fish_complete_path and fish_function_path for each module
if [ -d "$DOT_DIR/modules" ]
    for i in (ls "$DOT_DIR/modules" | sort)
        set -l i "$DOT_DIR/modules/$i"
        if [ -d "$i/shell/fish/functions" ]
            set fish_function_path "$i/shell/fish/functions" $fish_function_path
        end
        if [ -d "$i/shell/fish/completions" ]
            set fish_complete_path "$i/shell/fish/completions" $fish_complete_path
        end
    end
end


# Completions for dot-get are in /completions

# Functions for accessing the sys and cmd commands are in /functions


# Include guard
end
