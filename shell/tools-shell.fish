# -*- mode: fish -*-

## ----------------------------------------------------------
## Functions available in the shell
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_TOOLS_SHELL_FISH" ]
    set -g DOT_TOOLS_SHELL_FISH 1


# Get a list of downloaded modules
# Return:
#   $DOT_MODULES - a list of modules (separated by colons)
function _dot_get_modules
    set -e DOT_MODULES
    for i in (ls $DOT_DIR/modules | sort)
        set p "$DOT_DIR/modules/$i"
        if [ -d $p ]; and [ (basename $p) != "temp_clone" ]; and [ -f $p/.git/config ]
            set -g DOT_MODULES $DOT_MODULES $i
        end
    end
end


# Return names of modules containing the argument
# Args:
#   $argv[1] - Part of module name
# Return:
#   $DOT_MATCHING_MODULES - a list of matching modules (separated by colons)
function _dot_get_modules_matching_name
    set -e DOT_MATCHING_MODULES
    for i in $DOT_MODULES
        if string match -q "*$argv[1]*" "$i"
            set -g DOT_MATCHING_MODULES $DOT_MATCHING_MODULES $i
        end
    end
end


# Include guard
end
