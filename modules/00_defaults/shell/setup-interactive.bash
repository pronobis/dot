# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive, login and non-login
## Bash sessions.
## ----------------------------------------------------------

# Debugging info
export DOT_DEBUG="setup-interactive.bash:$$ $DOT_DEBUG"

# Add completion for cdot
__dot_cdot_completion()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    local DOT_MODULES
    __dot_get_modules
    COMPREPLY=( $(compgen -W "${DOT_MODULES//:/ }" -- ${cur}) )
    return 0
}
complete -F __dot_cdot_completion cdot
