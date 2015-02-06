# -*- mode: sh -*-

# Get paths to all modules in $DOT_MODULES
function dot_get_modules
{
    DOT_MODULES=()
    declare -a tmp
    tmp=( "$DOT_DIR/modules/*" )
    for i in ${tmp[@]}
    do
        if [ -d "$i" ]
        then
            DOT_MODULES[${#DOT_MODULES[@]}]="$i"
        fi
    done
    unset i
    unset tmp
}

# Create a link to a given binary
function dot_link_bin
{
    if [ -d "$1/bin" ]
    then
        ln -sf "$1/$2" "$1/bin"
    else
        echo "ERROR: No bin folder!"
    fi
}
