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

# Link to the internal config file
function dot_link_config
{
    mkdir -p $(dirname "${HOME}/$2")
    ln -sf "$1/config/$2" "${HOME}/$2"
}

# Make a copy of the config file
function dot_copy_config
{
    mkdir -p $(dirname "${HOME}/$2")
    if [ -e "${HOME}/$2" ]; then  # To prevent copying into a link
        rm "${HOME}/$2"
    fi
    cp "$1/config/$2" "${HOME}/$2"
}

# Copy the file and fill env. variables inside
function dot_fill_config
{
    mkdir -p $(dirname "${HOME}/$2")
    if [ -e "${HOME}/$2" ]; then  # To prevent copying into a link
        rm "${HOME}/$2"
    fi
    envsubst < "$1/config/$2" > "${HOME}/$2"
}
