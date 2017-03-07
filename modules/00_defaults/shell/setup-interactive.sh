# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive, login and non-login
## sessions for any POSIX shell.
## ----------------------------------------------------------

. "$DOT_DIR/shell/tools-shell.sh"


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
        _dot_get_modules
        _dot_get_modules_matching_name "$name"
        local IFS=':'
        set -- $DOT_MATCHING_MODULES
        cd "$DOT_DIR/modules/$1"
    else
        cd "$DOT_DIR/modules"
    fi
}

# Add completion for cdot
_cdot_completion()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    local DOT_MODULES
    _dot_get_modules
    COMPREPLY=( $(compgen -W "${DOT_MODULES//:/ }" -- ${cur}) )
    return 0
}
complete -o nospace -F _cdot_completion cdot
