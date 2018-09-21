# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive login and non-login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Debugging info
export DOT_DEBUG="setup-interactive.sh:$$ $DOT_DEBUG"

# Go to the module directory indicated by part of its name.
# If no argument is given, go to the directory containing all modules.
# Args:
#   $1 - Part of the module name
cdot()
{
    local name="$1"
    if [ -n "$name" ]
    then
        local DOT_MODULES
        local DOT_MATCHING_MODULES
        __dot_get_modules
        __dot_get_modules_matching_name "$name"
        local IFS=':'
        set -- $DOT_MATCHING_MODULES
        cd "$DOT_DIR/modules/$1"
    else
        cd "$DOT_DIR/modules"
    fi
}
