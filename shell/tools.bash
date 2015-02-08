# -*- mode: sh -*-

## -------------------------------------------------------------
## Printing
## -------------------------------------------------------------

# Colors
noformat="\e[0m"
bold="\e[1m"
light_yellow="\e[93m"
light_green="\e[92m"
light_red="\e[91m"
light_blue="\e[94m"
yellow="\e[33m"

function set_format
{
    echo -e -n "$1"
}

function clear_format
{
    echo -e -n "$noformat"
}


function print_main_header
{
    set_format ${bold}${light_yellow}
    echo "==============================="
    echo "Dotfiles Installer"
    echo "==============================="
    clear_format
    echo "Using dot files in: ${DOT_DIR}"
}


function print_main_footer
{
    set_format ${bold}${light_green}
    echo
    echo "==============================="
    echo "All done! "
    echo "Please install modules now. "
    echo "==============================="
    clear_format
}

function print_main_module_header
{
    set_format ${bold}${light_yellow}
    echo "==============================="
    echo "Dotfiles Module Installer "
    echo "==============================="
    clear_format
    echo "Using dot files in: ${DOT_DIR}"
}

function print_main_module_footer
{
    set_format ${bold}${light_green}
    echo
    echo "==============================="
    echo "All done! "
    echo "==============================="
    clear_format
}

function print_header
{
    set_format ${bold}${light_blue}
    echo
    echo "-------------------------------"
    echo -e "$1"
    echo "-------------------------------"
    clear_format
}

function print_info
{
    echo -e "$1"
}

function print_status
{
    set_format ${light_green}
    echo -e "$1"
    clear_format
}

function print_warning
{
    set_format ${yellow}
    echo -e "WARNING: $1"
    clear_format
}

function print_error
{
    set_format ${light_red}
    echo -e "ERROR: $1" 1>&2
    clear_format
}


## -------------------------------------------------------------
## Installing
## -------------------------------------------------------------

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
# Args:
#   $1 - Dot root dir
#   $2 - Path to the bin file relative to the dot root dir
function dot_link_bin
{
    if [ -d "$1/bin" ]
    then
        if [ -x $1/$2 ]
        then
           ln -sf "$1/$2" "$1/bin"
        else
            print_error "File $2 is not executable or does not exist!"
            exit -1
        fi
    else
        print_error "No bin folder!"
        exit -1
    fi
}

# Create a link to config files
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
function dot_link_config
{
    local IFS=$'\n'
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [[ -d "${HOME}/$i" && ! -L "${HOME}/$i" ]]
            then # Do not overwrite existing folders
                print_error "A directory ${HOME}/${i} already exists!"
                exit -1
            fi
            if [[ -e "${HOME}/$i" || -h "${HOME}/$i" ]]
            then # To prevent creation of a link on another link (e.g. link to folder)
                rm "${HOME}/$i"
            fi
            ln -s "$1/config/$i" "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}

# Create a link to system-wide config files
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to /
function dot_link_config_sys
{
    local IFS=$'\n'
    for i in $1/config-sys/$2
    do
        i=${i#$1/config-sys/}
        if [ -e "$1/config-sys/$i" ]
        then
            mkdir -p $(dirname "/$i")
            if [[ -d "/$i" && ! -L "/$i" ]]
            then # Do not overwrite existing folders
                print_error "A directory /${i} already exists!"
                exit -1
            fi
            if [[ -e "/$i" || -h "/$i" ]]
            then # To prevent creation of a link on another link (e.g. link to folder)
                rm "/$i"
            fi
            ln -s "$1/config-sys/$i" "/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}

# Make a copy of config files
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
function dot_copy_config
{
    local IFS=$'\n'
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [[ -d "${HOME}/$i" && ! -L "${HOME}/$i" ]]
            then # Do not overwrite existing folders
                print_error "A directory ${HOME}/${i} already exists!"
                exit -1
            fi
            if [[ -e "${HOME}/$i" || -h "${HOME}/$i" ]]
            then # To prevent copying into a link
                rm "${HOME}/$i"
            fi
            cp "$1/config/$i" "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done

}

# Copy config files and fill env. variables inside
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
function dot_fill_config
{
    local IFS=$'\n'
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [[ -d "${HOME}/$i" && ! -L "${HOME}/$i" ]]
            then # Do not overwrite existing folders
                print_error "A directory ${HOME}/${i} already exists!"
                exit -1
            fi
            if [[ -e "${HOME}/$i" || -h "${HOME}/$i" ]]
            then # To prevent copying into a link
                rm "${HOME}/$i"
            fi
            envsubst < "$1/config/$i" > "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}

# Copy system-wide config files and fill env. variables inside
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to /
function dot_fill_config_sys
{
    local IFS=$'\n'
    for i in $1/config-sys/$2
    do
        i=${i#$1/config-sys/}
        if [ -e "$1/config-sys/$i" ]
        then
            mkdir -p $(dirname "/$i")
            if [[ -d "/$i" && ! -L "/$i" ]]
            then # Do not overwrite existing folders
                print_error "A directory /${i} already exists!"
                exit -1
            fi
            if [[ -e "/$i" || -h "/$i" ]]
            then # To prevent copying into a link
                rm "/$i"
            fi
            envsubst < "$1/config-sys/$i" > "/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Add a section to the end of a possibly existing config file.
# If the section exists in the file, it is replaced.
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the config files relative to $HOME
#   $3 - Start tag of the section (typically a config file comment)
#   $4 - End tag of the section (typically a config file comment)
function dot_append_to_config
{
    local IFS=$'\n'
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [[ -e "${HOME}/$i" && ! -f "${HOME}/$i" ]]
            then
                print_error "${HOME}/${i} exists and is not a file!"
                exit -1
            fi
            if [ ! -e "${HOME}/$i" ]
            then # If file does not exist, create it
                touch "${HOME}/$i"
            fi
            # Now remove the old section that might exist
            local safe3=$(printf '%s\n' "$3" | sed 's/[[\.*^$/]/\\&/g')
            local safe4=$(printf '%s\n' "$4" | sed 's/[[\.*^$/]/\\&/g')
            sed -i "/$safe3/,/$safe4/d" "${HOME}/$i"
            # Add our section
            echo "$3" >> "${HOME}/$i"
            cat "$1/config/$i" >> "${HOME}/$i"
            echo "$4" >> "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Add a section to the beginning of a possibly existing config file.
# If the section exists in the file, it is replaced.
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the config files relative to $HOME
#   $3 - Start tag of the section (typically a config file comment)
#   $4 - End tag of the section (typically a config file comment)
function dot_prepend_to_config
{
    local IFS=$'\n'
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [[ -e "${HOME}/$i" && ! -f "${HOME}/$i" ]]
            then
                print_error "${HOME}/${i} exists and is not a file!"
                exit -1
            fi
            if [ ! -e "${HOME}/$i" ]
            then # If file does not exist, create it
                touch "${HOME}/$i"
            fi
            # Now remove the old section that might exist
            local safe3=$(printf '%s\n' "$3" | sed 's/[[\.*^$/]/\\&/g')
            local safe4=$(printf '%s\n' "$4" | sed 's/[[\.*^$/]/\\&/g')
            sed -i "/$safe3/,/$safe4/d" "${HOME}/$i"
            # Add our section
            echo -e "$3\n$(cat "$1/config/$i")\n$4\n$(cat ${HOME}/$i)" > "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}



## -------------------------------------------------------------
## Other
## -------------------------------------------------------------

# Check if the user is root
function check_root
{
    if [[ $EUID -ne 0 || $HOME != "/root" ]]
    then
        print_error "This script must be run as root!"
        exit -1
    fi
}

# Check if the user is root
function check_not_root
{
    if [[ $EUID -eq 0 || $HOME == "/root" ]]
    then
        print_error "This script should not be run as root!"
        exit -1
    fi
}