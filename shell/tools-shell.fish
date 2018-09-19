# -*- mode: fish -*-

## ----------------------------------------------------------
## Functions available in the shell
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_TOOLS_SHELL_FISH" ]
    set -g DOT_TOOLS_SHELL_FISH 1


# Get a list of downloaded modules
# Return:
#   - A list of modules
function __dot_get_modules
    for i in (ls $DOT_DIR/modules | sort)
        set p "$DOT_DIR/modules/$i"
        if [ -d $p ]; and [ (basename $p) != "temp_clone" ]; and [ -f $p/.git/config ]
            echo $i
        end
    end
end


# Return names of modules containing the argument
# Args:
#   $argv[1] - Part of module name
# Return:
#   - A list of matching modules (separated by colons)
function __dot_get_modules_matching_name
    for i in (__dot_get_modules)
        if string match -q "*$argv[1]*" "$i"
            echo $i
        end
    end
end


# Add path to $PATH
# Args:
#   $1 - The path to add
function __dot_add_path
    if not contains $argv[1] $PATH; and [ -d $argv[1] ]
        set -gx PATH $argv[1] $PATH
    end
end


# Add path to a colon-separated list of paths
# Args:
#   $1 - Name of variable holding the list
#   $2 - The path to add
function __dot_add_path_to_list
    if not echo "$$argv[1]" | grep -Eq '(^|:)'$argv[2]'($|:)'; and [ -d $argv[2] ]
        if [ -z "$$argv[1]" ]
            set -gx $argv[1] $argv[2]
        else
            set -gx $argv[1] "$argv[2]:$$argv[1]"
        end
    end
end


# Include guard
end
