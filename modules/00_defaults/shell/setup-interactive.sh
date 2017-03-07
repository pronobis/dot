# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive, login and non-login
## sessions for any POSIX shell.
## ----------------------------------------------------------

# Go to the module directory indicated by part of its name.
# If no argument is given, go to the directory containing all modules.
# Args:
#   $1 - Part of the module name
cdot()
{
    local name="$1"
    if [ -n "$name" ]
    then
        # Find first module matching name
        for i in `ls $DOT_DIR/modules | sort`
        do
            if [ "${i/$name/}" != "$i" ]
            then
                cd $DOT_DIR/modules/$i
                break
            fi
        done
    else
        cd $DOT_DIR/modules
    fi
}
