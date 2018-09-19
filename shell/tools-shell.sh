# -*- mode: sh -*-

## ----------------------------------------------------------
## Functions available in the shell
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_TOOLS_SHELL_SH" ] && return || readonly DOT_TOOLS_SHELL_SH=1

# Include formatting
. "$DOT_DIR/shell/formatting.sh"


# Get a list of downloaded modules
# Return:
#   $DOT_MODULES - a list of modules (separated by colons)
_dot_get_modules()
{
    DOT_MODULES=""
    local p=""
    for i in `ls $DOT_DIR/modules | sort`
    do
        p="$DOT_DIR/modules/$i"
        if [ -d "$p" ] && [ $(basename "$p") != "temp_clone" ] && [ -f $p/.git/config ]
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
_dot_get_modules_matching_name()
{
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
