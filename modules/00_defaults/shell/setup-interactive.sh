# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive, login and non-login
## sessions for any POSIX shell.
## ----------------------------------------------------------

cdot()
{
    local name="$1"
    if [ -n "$name" ]
    then
        # Find first module matching name
        for i in `ls $DOT_DIR/modules | sort`
        do
            if [ "${i#$name}" != "$i" ]
            then
                cd $DOT_DIR/modules/$i
            fi
        done
    else
        cd $DOT_DIR/modules
    fi
}
