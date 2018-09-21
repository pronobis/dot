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

# Functions for accessing the sys and cmd commands
function sys
    if eval $DOT_DIR/scripts/sys $argv; and [ -d "$DOT_DIR/system" ]
        [ -f "$DOT_DIR/system/setup.all" ]; and source "$DOT_DIR/system/setup.all"
        [ -f "$DOT_DIR/system/setup.fish" ]; and source "$DOT_DIR/system/setup.fish"
    end
end
function cmd
    if eval $DOT_DIR/scripts/cmd $argv; and [ -d "$DOT_DIR/system" ]
        [ -f "$DOT_DIR/system/setup.all" ]; and source "$DOT_DIR/system/setup.all"
        [ -f "$DOT_DIR/system/setup.fish" ]; and source "$DOT_DIR/system/setup.fish"
    end
end

# Add completions for dot-get
complete -c dot-get -x  # No completions initially
complete -c dot-get -n '__fish_use_subcommand' -xa list -d 'List all modules'  # Add subcommand if none given
complete -c dot-get -n '__fish_use_subcommand' -xa status -d 'Show module status'
complete -c dot-get -n '__fish_use_subcommand' -xa add -d 'Add a new module'
complete -c dot-get -n '__fish_use_subcommand' -xa update -d 'Update a module'
complete -c dot-get -n '__fish_use_subcommand' -xa resolve -d 'Resolve missing deps'
complete -c dot-get -n '__fish_use_subcommand' -a install -d 'Install a module'
# - Add list of modules to install/update if subcommand is install/update and module is not yet provided (only 2 cmds in cmd line)
complete -c dot-get -n '__fish_seen_subcommand_from update; and test (__fish_number_of_cmd_args_wo_opts) = 2' -xa 'all' -d 'All modules'
complete -c dot-get -n '__fish_seen_subcommand_from update; and test (__fish_number_of_cmd_args_wo_opts) = 2' -xa 'dot' -d 'Dot itself'
complete -c dot-get -n '__fish_seen_subcommand_from update install; and test (__fish_number_of_cmd_args_wo_opts) = 2' -xa '(__dot_get_modules)'


# Include guard
end
