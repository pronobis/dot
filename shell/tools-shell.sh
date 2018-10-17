# -*- mode: sh -*-
## ----------------------------------------------------------
## Functions available in the shell
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_TOOLS_SHELL_SH" ] && return || readonly DOT_TOOLS_SHELL_SH=1

# Include formatting
. "$DOT_DIR/shell/formatting.sh"


# Print a status info
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


# Return names of modules containing the argument
# Args:
#   $1 - Part of module name
# Return:
#   $DOT_MATCHING_MODULES - a list of matching modules (separated by colons)
__dot_get_modules_matching_name()
{
    DOT_MATCHING_MODULES=""
    local IFS=':'
    for i in $DOT_MODULES
    do
        if [ "${i#*$1}" != "$i" ]
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
