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

# Create a link to config files
function dot_link_config
{
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            ln -sf "$1/config/$i" "${HOME}/$i"
        fi
    done
}

# Make a copy of config files
function dot_copy_config
{
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -e "${HOME}/$i" ]; then  # To prevent copying into a link
                rm "${HOME}/$i"
            fi
            cp "$1/config/$i" "${HOME}/$i"
        fi
    done

}

# Copy config files and fill env. variables inside
function dot_fill_config
{
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -e "${HOME}/$i" ]; then  # To prevent copying into a link
                rm "${HOME}/$i"
            fi
            envsubst < "$1/config/$i" > "${HOME}/$i"
        fi
    done
}
