# Go to the module directory indicated by part of its name.
# If no argument is given, go to the directory containing all modules.
# Args:
#   $argv[1] - Part of the module name
function cdot --argument-names 'module' --description 'Go to dot module directory'
    set -l name $argv[1]
    if [ -n "$name" ]
        set -l res (__dot_get_modules_matching_name "$name")
        cd "$DOT_DIR/modules/$res[1]"
    else
        cd "$DOT_DIR/modules"
    end
end
