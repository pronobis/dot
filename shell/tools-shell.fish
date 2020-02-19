# -*- mode: fish -*-

## ----------------------------------------------------------
## Functions available in the shell
## ----------------------------------------------------------

# Include guard
if [ -z "$DOT_TOOLS_SHELL_FISH" ]
    set -g DOT_TOOLS_SHELL_FISH 1


# Print a status info
# Args:
#   $argv[1] - Fromat
#   $argv[2..] - Arguments
function __dot_print_status
    set_color brgreen
    printf "$argv[1]\n" $argv[2..-1]
    set_color normal
end


# Print a warning
# Args:
#   $argv[1] - Fromat
#   $argv[2..] - Arguments
function __dot_print_warning
    set_color bryellow
    printf "WARNING: $argv[1]\n" $argv[2..-1]
    set_color normal
end


# Print an error
# Args:
#   $argv[1] - Fromat
#   $argv[2..] - Arguments
function __dot_print_error
    set_color brred
    printf "ERROR: $argv[1]\n" $argv[2..-1] 1>&2
    set_color normal
end


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


# Return names of modules containing the part of argument
# the argument before "/".
# Args:
#   $argv[1] - Part of module name
# Return:
#   - A list of matching modules (separated by colons)
function __dot_get_modules_matching_name
    set -l name (string replace -r "/.*" "" "$argv[1]")
    for i in (__dot_get_modules)
        if string match -q "*$name*" "$i"
            echo $i
        end
    end
end


# Add a path to the front of a list of paths
# if the path exists and is a directory.
# Args:
#   $argv[1] - Name of variable holding the list
#   $argv[2] - The path to add
function __dot_add_path
    # Check args
    if [ (count $argv) -lt 2 ]
        __dot_print_error "__dot_add_path: Incorrect arguments ('%s' '%s'). Must be (<var> <path>)." $argv[1] $argv[2]
        return 1
    end
    # Special case for PATH
    if [ "$argv[1]" = "PATH" ]
        if not contains $argv[2] $PATH; and [ -d $argv[2] ]
            set -gx PATH $argv[2] $PATH
        end
    # Other colon separated lists
    else
        if not echo "$$argv[1]" | grep -Eq '(^|:)'$argv[2]'($|:)'; and [ -d $argv[2] ]
            if [ -z "$$argv[1]" ]
                set -gx $argv[1] $argv[2]
            else
                set -gx $argv[1] "$argv[2]:$$argv[1]"
            end
        end
    end
end


# Add an abbreviation
# Args:
#   $argv[1] - Name of the abbreviation
#   $argv[2] - Content of the abbreviation
function __dot_abbr
    abbr -g -a $argv[1] $argv[2]
end


# Load parameters of all modules
# Options:
#   -r - Force reload
function __dot_load_params
    # Do nothing if params already loaded, unless reloading
    if [ "$argv[1]" = "-r" ]; or [ -z "$DOT_PARAMS_LOADED" ]
        set -gx DOT_PARAMS_LOADED 1

        # Unset any previous params
        for i in (env | awk '/^DOT_PARAM_/ {sub(/\s*=.*/,"", $1); print $1}')
            set -e $i
        end

        # Load params found in each module
        if [ -d "$DOT_DIR/modules" ]
            for i in (ls "$DOT_DIR/modules" | sort)
                set -l i "$DOT_DIR/modules/$i"
                if [ -d "$i" ]
                    # Run in each module
                    if [ -f "$i/params" ]
                        # Load params as environment variables
                        awk '/^[[:alnum:]_]+=/{print "export DOT_PARAM_"$0}' "$i/params" | source
                    end
                end
            end
        end
    end
end


# Get the value of a parameter and print it to stdout.
# Options:
#   -q - Stay quiet, do not print
#   -n - Test if parameter is not empty
# Args:
#   $1 - Parameter name
# Return:
#   $? - 0 if parameter is set (not empty), 1 otherwise (for -n)
#   $DOT_PARAM - parameter value
function __dot_param
    # Parse options
    argparse 'q' 'n' -- $argv
    # Get param
    set -l var "DOT_PARAM_$argv[1]"
    set -g DOT_PARAM "$$var"
    if [ -n "$DOT_PARAM" ]
        [ -n "$_flag_q" ]
        or echo "$DOT_PARAM"
    else
        [ -z "$_flag_n" ]
    end
end


# Check if parameter is set to '1', 'yes', or 'true'
# Args:
#   $1 - Parameter name
# Return:
#   $? - 0 if parameter was set to true, 1 otherwise
function __dot_true
    set -l val (__dot_param "$argv[1]" | string upper)
    [ "$val" = "1" ] || [ "$val" = "TRUE" ] || [ "$val" = "YES" ]
end


# Check if parameter is set to '0', 'no', or 'false'
# Args:
#   $1 - Parameter name
# Return:
#   $? - 0 if parameter was set to true, 1 otherwise
function __dot_false
    set -l val (__dot_param "$argv[1]" | string upper)
    [ "$val" = "0" ] || [ "$val" = "FALSE" ] || [ "$val" = "NO" ]
end


# Include guard
end
