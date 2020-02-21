# -*- mode: sh -*-
## ----------------------------------------------------------
## Functions available in the shell
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_TOOLS_SHELL_SH" ] && return || readonly DOT_TOOLS_SHELL_SH=1

# Include formatting
. "$DOT_DIR/shell/formatting.sh"


# Print a status message
# Args:
#   $1 - Fromat
#   $2- - Arguments
__dot_print_status()
{
    local fmt="$1"
    shift
    set_format ${LIGHT_GREEN}
    printf "$fmt\n" "$@"
    clear_format
}


# Print a warning
# Args:
#   $1 - Fromat
#   $2- - Arguments
__dot_print_warning()
{
    local fmt="$1"
    shift
    set_format ${YELLOW}
    printf "WARNING: $fmt\n" "$@"
    clear_format
}


# Print an error
# Args:
#   $1 - Fromat
#   $2- - Arguments
__dot_print_error()
{
    local fmt="$1"
    shift
    set_format ${LIGHT_RED}
    printf "ERROR: $fmt\n" "$@" 1>&2
    clear_format
}


# Get a list of downloaded modules
# Return:
#   $DOT_MODULES - a list of modules (separated by colons)
__dot_get_modules()
{
    DOT_MODULES=""
    local p=""
    for i in `ls $DOT_DIR/modules | sort`
    do
        p="$DOT_DIR/modules/$i"
        if [ -d "$p" ] && [ $(basename "$p") != "temp_clone" ] && [ -f "$p/.git/config" ]
        then
            DOT_MODULES=${DOT_MODULES:+${DOT_MODULES}:}$i
        fi
    done
}


# Return names of modules containing the part of argument
# the argument before "/".
# Args:
#   $1 - Part of module name
# Return:
#   $DOT_MATCHING_MODULES - a list of matching modules (separated by colons)
__dot_get_modules_matching_name()
{
    local name="${1%%/*}"
    DOT_MATCHING_MODULES=""
    local IFS=':'
    for i in $DOT_MODULES
    do
        if [ "${i#*$name}" != "$i" ]
        then
            DOT_MATCHING_MODULES=${DOT_MATCHING_MODULES:+${DOT_MATCHING_MODULES}:}$i
        fi
    done

}


# Add a path to the front of a list of paths
# if the path exists and is a directory.
# Args:
#   $1 - Name of variable holding the list
#   $2 - The path to add
__dot_add_path()
{
    # Check args
    if [ $# -lt 2 ]
    then
        __dot_print_error "__dot_add_path: Incorrect arguments ('%s' '%s'). Must be (<var> <path>)." "$1" "$2"
        return 1
    fi
    # Add path
    if ! eval "echo \${$1}" | grep -Eq "(^|:)$2($|:)" && [ -d "$2" ]
    then
        eval "export $1=\"$2\${$1:+:\${$1}}\""
    fi
}


# Add an abbreviation
# Args:
#   $1 - Name of the abbreviation
#   $2 - Content of the abbreviation
__dot_abbr()
{
    alias "$1"="$2"
}


# Load parameters of all modules
# Options:
#   -r - Force reload
__dot_load_params()
{
    # Do nothing if params already loaded, unless reloading
    [ ! "$1" = "-r" ] && [ -n "$DOT_PARAMS_LOADED" ] && return || export DOT_PARAMS_LOADED=1

    # Unset any previous params
    for i in $(env | awk '/^DOT_PARAM_/ {sub(/\s*=.*/,"", $1); print $1}')
    do
        unset $i
    done

    # Load params found in each module
    if [ -d "$DOT_DIR/modules" ]
    then
        for i in `ls $DOT_DIR/modules | sort`; do
            i="$DOT_DIR/modules/$i"
            if [ -d "$i" ]
            then
                if [ -f "$i/params" ]
                then
                    # Load params as environment variables
                    eval "$(awk 'BEGIN{ORS=";"} /^[[:alnum:]_]+=/{print "export DOT_PARAM_"$0}' "$i/params")"
                fi
            fi
        done
    fi
}


# Get the value of a parameter and print it to stdout.
# Options:
#   -q - Stay quiet, do not print
#   -n - Test if parameter is not empty
# Args:
#   $1 - Parameter name
# Return:
#   $? - 0 if parameter is set (not empty), 1 otherwise (for -n)
#   $DOT_PARAM - parameter value
__dot_param()
{
    # Parse options
    while true
    do
        case $1 in
            -q)
                local arg_quiet=1
                shift
                ;;
            -n)
                local arg_test_empty=1
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    # Get param
    eval "DOT_PARAM=\"\$DOT_PARAM_$1\""
    if [ -n "$DOT_PARAM" ]
    then
        [ -n "$arg_quiet" ] || echo -n "$DOT_PARAM"
    else
        [ -z "$arg_test_empty" ]
    fi
}


# Check if parameter is set to '1', 'yes', or 'true'
# Args:
#   $1 - Parameter name
# Return:
#   $? - 0 if parameter was set to true, 1 otherwise
__dot_true()
{
    local val="$(__dot_param "$1" | tr a-z A-Z)"
    [ "$val" = "1" ] || [ "$val" = "TRUE" ] || [ "$val" = "YES" ]
}


# Check if parameter is set to '0', 'no', or 'false'
# Args:
#   $1 - Parameter name
# Return:
#   $? - 0 if parameter was set to true, 1 otherwise
__dot_false()
{
    local val="$(__dot_param "$1" | tr a-z A-Z)"
    [ "$val" = "0" ] || [ "$val" = "FALSE" ] || [ "$val" = "NO" ]
}
