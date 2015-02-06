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
    echo -e "ERROR: $1"
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
function dot_link_config
{
    local IFS=$'\n'
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            ln -sf "$1/config/$i" "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}

# Make a copy of config files
function dot_copy_config
{
    local IFS=$'\n'
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
        else
            print_warning "No config file $i found!"
        fi
    done

}

# Copy config files and fill env. variables inside
function dot_fill_config
{
    local IFS=$'\n'
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
        else
            print_warning "No config file $i found!"
        fi
    done
}
