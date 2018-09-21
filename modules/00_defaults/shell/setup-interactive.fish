# -*- mode: fish -*-
## ----------------------------------------------------------
## Executed for interactive login and non-login
## Fish sessions.
## ----------------------------------------------------------

# Debugging info
set -gx DOT_DEBUG "setup-interactive.fish:"(echo %self)" $DOT_DEBUG"

# Go to the module directory indicated by part of its name.
# If no argument is given, go to the directory containing all modules.
# Args:
#   $argv[1] - Part of the module name
function cdot
    set -l name $argv[1]
    if [ -n "$name" ]
        set -l res (__dot_get_modules_matching_name "$name")
        cd "$DOT_DIR/modules/$res[1]"
    else
        cd "$DOT_DIR/modules"
    end
end

# Add completion for cdot
complete -c cdot -xa '(__dot_get_modules)'
