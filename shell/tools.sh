# -*- mode: sh -*-
## -------------------------------------------------------------
## Functions used by dot scripts
## -------------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_TOOLS" ] && return || readonly DOT_SETUP_TOOLS=1

# Include formatting
. "$DOT_DIR/shell/formatting.sh"

# Include shell tools
. "$DOT_DIR/shell/tools-shell.sh"


## -------------------------------------------------------------
## Printing
## -------------------------------------------------------------

print_main_header()
{
    set_format ${BOLD}${LIGHT_YELLOW}
    echo "==============================="
    echo "Dotfiles Installer"
    echo "==============================="
    clear_format
    echo "Using dot files in: ${DOT_DIR}"
}


print_main_footer()
{
    set_format ${BOLD}${LIGHT_GREEN}
    echo
    echo "==============================="
    echo "All done! "
    echo "Please install modules now. "
    echo "==============================="
    clear_format
}

print_main_module_header()
{
    set_format ${BOLD}${LIGHT_YELLOW}
    echo "==============================="
    echo "Dotfiles Module Installer "
    echo "==============================="
    clear_format
    echo "Using dot files in: ${DOT_DIR}"
}

print_main_module_footer()
{
    set_format ${BOLD}${LIGHT_GREEN}
    echo
    echo "==============================="
    echo "All done! "
    echo "==============================="
    clear_format
}

print_header()
{
    set_format ${BOLD}${LIGHT_BLUE}
    echo
    echo "-------------------------------"
    printf "$1\n" "$2"
    echo "-------------------------------"
    clear_format
}

print_info()
{
    printf "$1\n" "$2"
}

print_status()
{
    __dot_print_status "$@"
}

print_warning()
{
    __dot_print_warning "$@"
}

print_error()
{
    __dot_print_error "$@"
}


## -------------------------------------------------------------
## Interaction
## -------------------------------------------------------------

## Ask a yes/no question
## Args:
##   $1 - Question text
yes_no_question()
{
    printf "${BOLD}${YELLOW}$1 ${WHITE}(${LIGHT_GREEN}y${WHITE}/${LIGHT_RED}N${WHITE}):${NO_FORMAT} "
    old_stty_cfg=$(stty -g)
    stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
    if echo "$answer" | grep -iq "^y"
    then # Yes
        printf "${BOLD}${LIGHT_GREEN}y${NO_FORMAT}\n"
        return 0
    elif [ "$answer" = $(printf \\003) ]
    then # ^C detected
        printf "${BOLD}${LIGHT_RED}interrupted${NO_FORMAT}\n"
        exit 1
    else # No
        printf "${BOLD}${LIGHT_RED}n${NO_FORMAT}\n"
        return 1
    fi
}


## Wait for any user input
wait_for_key()
{
    printf "${BOLD}${YELLOW}Press any key to continue...${NO_FORMAT} "
    old_stty_cfg=$(stty -g)
    stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
    if [ "$answer" = $(printf \\003) ]
    then # ^C detected
        printf "${BOLD}${LIGHT_RED}interrupted${NO_FORMAT}\n"
        exit 1
    else # any other key
        printf "\n"
    fi
}


## -------------------------------------------------------------
## Installing
## -------------------------------------------------------------
# Execute the command and inhibit the output unless an error
# occurs, in which case print stdout and stderr of the original
# command to stdout. Return the original exit status.
# Args:
#   $@ - command with arguments
# Return:
#   $? - command exit status
dot_inhibit()
{
    local out=""  # To avoid "bad variable name" in dash for some values
    local ret_status=""
    set +e
    out=$("$@" 2>&1)
    ret_status=$?
    if [ $ret_status -ne 0 ]
    then
        printf "%s\n" "$out"
        print_error "Command '%s' failed!\n" "$@"
    fi
    set -e
    return $ret_status
}


# Try finding git, even if PATH is not set
# Return:
#   DOT_GIT - absolute path to the git command
dot_get_git()
{
    set +e
    DOT_GIT=$(which git)
    # Try finding git, even it PATH is not set properly
    [ -z "$git" ] && [ -x /usr/bin/git ] && DOT_GIT=/usr/bin/git
    [ -z "$git" ] && [ -x /opt/bin/git ] && DOT_GIT=/opt/bin/git
    [ -z "$git" ] && [ -x /bin/git ] && DOT_GIT=/bin/git
    set -e
}


# Get an appropriate su/sudo command or nothing if running as root
# Return:
#   DOT_SU - the su command
dot_get_su()
{
    uid="$(id -u)"  # The only way that works with dash
    if [ "$uid" = "0" ] || [ "$HOME" = "/root" ] || [ "$USER" = "root" ] || [ "$(whoami)" = "root" ]
    then
        # Running as root, don't use su
        DOT_SU=""
    else
        if dot_check_cmd sudo
        then
            # Prefer sudo if available
            DOT_SU="sudo"
        elif dot_check_cmd su
        then
            # Use su if available
            DOT_SU="su"
        else
            # Fallback to nothing
            DOT_SU=""
        fi
    fi
}


# Create a link to a given binary
# Args:
#   $1 - Path to the bin file relative to the dot root dir
dot_link_bin()
{
    if [ -d "${DOT_MODULE_DIR}/bin" ]
    then
        if [ -x "${DOT_MODULE_DIR}/$1" ]
        then
            ln -sf "${DOT_MODULE_DIR}/$1" "${DOT_MODULE_DIR}/bin"
        else
            print_error "File $1 is not executable or does not exist!"
            exit 1
        fi
    else
        print_error "No bin folder!"
        exit 1
    fi
}


# Create a link to config files
# Args:
#   $1 - Wildcard describing the path to config files relative to $HOME
dot_link_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config/$1
    do
        i=${i#${DOT_MODULE_DIR}/config/}
        if [ -e "${DOT_MODULE_DIR}/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -d "${HOME}/$i" ] && [ ! -L "${HOME}/$i" ]
            then # Do not overwrite existing folders
                print_error "${HOME}/${i} already exists and is a directory!"
                exit 1
            fi
            if [ -e "${HOME}/$i" ] || [ -h "${HOME}/$i" ]
            then # To prevent creation of a link on another link (e.g. link to folder)
                rm "${HOME}/$i"
            fi
            ln -s "${DOT_MODULE_DIR}/config/$i" "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Create a link to system-wide config files
# Args:
#   $1 - Wildcard describing the path to config files relative to /
dot_link_config_sys()
{
    dot_get_su

    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config-sys/$1
    do
        i=${i#${DOT_MODULE_DIR}/config-sys/}
        if [ -e "${DOT_MODULE_DIR}/config-sys/$i" ]
        then
            $DOT_SU mkdir -p $(dirname "/$i")
            if $DOT_SU test -d "/$i" && $DOT_SU test ! -L "/$i"
            then # Do not overwrite existing folders
                print_error "/${i} already exists and is a directory!"
                exit 1
            fi
            if $DOT_SU test -e "/$i" || $DOT_SU test -h "/$i"
            then # To prevent creation of a link on another link (e.g. link to folder)
                $DOT_SU rm "/$i"
            fi
            $DOT_SU ln -s "${DOT_MODULE_DIR}/config-sys/$i" "/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Create a link to a user config file in the root home
# Args:
#   $1 - Wildcard describing the path to config files relative to user's home
dot_link_user_root()
{
    dot_get_su

    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $HOME/$1
    do
        i=${i#$HOME/}
        if [ -e "$HOME/$i" ]
        then
            $DOT_SU mkdir -p $(dirname "/root/$i")
            if $DOT_SU test -d "/root/$i" && $DOT_SU test ! -L "/root/$i"
            then # Do not overwrite existing folders
                print_error "/root/${i} already exists and is a directory!"
                exit 1
            fi
            if $DOT_SU test -e "/root/$i" || $DOT_SU test -h "/root/$i"
            then # To prevent creation of a link on another link (e.g. link to folder)
                $DOT_SU rm "/root/$i"
            fi
            $DOT_SU ln -s "$HOME/$i" "/root/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# A generic link function for files in user's home folder
# with some convenience and safety features
# Args:
#   $1 - Target relative to $HOME
#   $2 - Link path relative to $HOME
dot_link_user()
{
    local from=""
    local to=""
    from="$HOME/$1"
    to="$HOME/$2"
    if [ ! -e "$from" ]
    then
        print_warning "Link target $from not found. Link will still be created."
    fi

    mkdir -p $(dirname "$to")
    if [ -d "$to" ] && [ ! -L "$to" ]
    then # Do not overwrite existing folders
        print_error "$to already exists and is a directory!"
        exit 1
    fi
    if [ -e "$to" ] || [ -h "$to" ]
    then # To prevent creation of a link on another link (e.g. link to folder)
        rm "$to"
    fi
    ln -s "$from" "$to"
}


# Create a directory in the user's home folder
# Args:
#   $1 - Path relative to $HOME
dot_mkdir_user()
{
    local pth=""
    pth="$HOME/$1"
    if [ -f "$pth" ]
    then
        print_error "Target $pth exists and is a file!"
        exit 1
    fi
    mkdir -p "$pth"
}


# Make a copy of config files
# Args:
#   $1 - Wildcard describing the path to config files relative to $HOME
dot_copy_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config/$1
    do
        i=${i#${DOT_MODULE_DIR}/config/}
        if [ -e "${DOT_MODULE_DIR}/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -d "${HOME}/$i" ] && [ ! -L "${HOME}/$i" ]
            then # Do not overwrite existing folders
                print_error "${HOME}/${i} already exists and is a directory!"
                exit 1
            fi
            if [ -e "${HOME}/$i" ] || [ -h "${HOME}/$i" ]
            then # To prevent copying into a link
                rm "${HOME}/$i"
            fi
            cp -d "${DOT_MODULE_DIR}/config/$i" "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Make a copy of config files system-wide
# Args:
#   $1 - Wildcard describing the path to config files relative to $HOME
dot_copy_config_sys()
{
    dot_get_su

    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config-sys/$1
    do
        i=${i#${DOT_MODULE_DIR}/config-sys/}
        if [ -e "${DOT_MODULE_DIR}/config-sys/$i" ]
        then
            $DOT_SU mkdir -p $(dirname "/$i")
            if $DOT_SU test -d "/$i" && $DOT_SU test ! -L "/$i"
            then # Do not overwrite existing folders
                print_error "/${i} already exists and is a directory!"
                exit 1
            fi
            if $DOT_SU test -e "/$i" || $DOT_SU test -h "/$i"
            then # To prevent copying into a link
                $DOT_SU rm "/$i"
            fi
            $DOT_SU cp -d "${DOT_MODULE_DIR}/config-sys/$i" "/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Copy config files and fill env. variables inside
# Args:
#   $1 - Wildcard describing the path to config files relative to $HOME
dot_fill_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config/$1
    do
        i=${i#${DOT_MODULE_DIR}/config/}
        if [ -e "${DOT_MODULE_DIR}/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -d "${HOME}/$i" ] && [ ! -L "${HOME}/$i" ]
            then # Do not overwrite existing folders
                print_error "${HOME}/${i} already exists and is a directory!"
                exit 1
            fi
            if [ -e "${HOME}/$i" ] || [ -h "${HOME}/$i" ]
            then # To prevent copying into a link
                rm "${HOME}/$i"
            fi
            # envsubst < "${DOT_MODULE_DIR}/config/$i" > "${HOME}/$i"  # Does not work with busybox
            sed \
                -e 's#${USER}#'"${USER}"'#g' \
                -e 's#${HOME}#'"${HOME}"'#g' \
                -e 's#${DOT_DIR}#'"${DOT_DIR}"'#g' \
                -e 's#${DOT_MODULE_DIR}#'"${DOT_MODULE_DIR}"'#g' \
                "${DOT_MODULE_DIR}/config/$i" > "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Copy system-wide config files and fill env. variables inside
# Args:
#   $1 - Wildcard describing the path to config files relative to /
dot_fill_config_sys()
{
    dot_get_su

    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config-sys/$1
    do
        i=${i#${DOT_MODULE_DIR}/config-sys/}
        if [ -e "${DOT_MODULE_DIR}/config-sys/$i" ]
        then
            $DOT_SU mkdir -p $(dirname "/$i")
            if $DOT_SU test -d "/$i" && $DOT_SU test ! -L "/$i"
            then # Do not overwrite existing folders
                print_error "/${i} already exists and is a directory!"
                exit 1
            fi
            if $DOT_SU test -e "/$i" || $DOT_SU test -h "/$i"
            then # To prevent copying into a link
                $DOT_SU rm "/$i"
            fi
            # envsubst < "${DOT_MODULE_DIR}/config-sys/$i" > "/$i"  # Does not work with busybox
            sed \
                -e 's#${USER}#'"${USER}"'#g' \
                -e 's#${HOME}#'"${HOME}"'#g' \
                -e 's#${DOT_DIR}#'"${DOT_DIR}"'#g' \
                -e 's#${DOT_MODULE_DIR}#'"${DOT_MODULE_DIR}"'#g' \
                "${DOT_MODULE_DIR}/config-sys/$i" | $DOT_SU tee "/$i" > /dev/null
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Append to the end of a possibly existing config file.
# Args:
#   $1 - Wildcard describing the config files relative to $HOME
dot_append_to_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config/$1
    do
        i=${i#${DOT_MODULE_DIR}/config/}
        if [ -e "${DOT_MODULE_DIR}/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -e "${HOME}/$i" ] && [ ! -f "${HOME}/$i" ]
            then
                print_error "${HOME}/${i} exists and is not a file!"
                exit 1
            fi
            if [ ! -e "${HOME}/$i" ]
            then # If file does not exist, create it
                touch "${HOME}/$i"
            fi
            # Append
            cat "${DOT_MODULE_DIR}/config/$i" >> "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Add a section to the end of a possibly existing config file.
# If the section exists in the file, it is replaced.
# Args:
#   $1 - Wildcard describing the config files relative to $HOME
#   $2 - Start tag of the section (typically a config file comment)
#   $3 - End tag of the section (typically a config file comment)
dot_append_section_to_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config/$1
    do
        i=${i#${DOT_MODULE_DIR}/config/}
        if [ -e "${DOT_MODULE_DIR}/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -e "${HOME}/$i" ] && [ ! -f "${HOME}/$i" ]
            then
                print_error "${HOME}/${i} exists and is not a file!"
                exit 1
            fi
            if [ ! -e "${HOME}/$i" ]
            then # If file does not exist, create it
                touch "${HOME}/$i"
            fi
            # Now remove the old section that might exist
            local safe3=$(printf '%s\n' "$2" | sed 's/[[\.*^$/]/\\&/g')
            local safe4=$(printf '%s\n' "$3" | sed 's/[[\.*^$/]/\\&/g')
            sed -i "/$safe3/,/$safe4/d" "${HOME}/$i"
            # Add our section
            echo "$2" >> "${HOME}/$i"
            cat "${DOT_MODULE_DIR}/config/$i" >> "${HOME}/$i"
            echo "$3" >> "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Add a section to the end of a possibly existing config file.
# If the section exists in the file, it is replaced.
# Args:
#   $1 - Wildcard describing the config files relative to $HOME
#   $2 - Start tag of the section (typically a config file comment)
#   $3 - End tag of the section (typically a config file comment)
dot_append_section_to_config_sys()
{
    dot_get_su

    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config-sys/$1
    do
        i=${i#${DOT_MODULE_DIR}/config-sys/}
        if [ -e "${DOT_MODULE_DIR}/config-sys/$i" ]
        then
            $DOT_SU mkdir -p $(dirname "/$i")
            if $DOT_SU test -e "/$i" && $DOT_SU test ! -f "/$i"
            then
                print_error "/${i} exists and is not a file!"
                exit 1
            fi
            if $DOT_SU test ! -e "/$i"
            then # If file does not exist, create it
                $DOT_SU touch "/$i"
            fi
            # Now remove the old section that might exist
            local safe3=$(printf '%s\n' "$2" | sed 's/[[\.*^$/]/\\&/g')
            local safe4=$(printf '%s\n' "$3" | sed 's/[[\.*^$/]/\\&/g')
            $DOT_SU sed -i "/$safe3/,/$safe4/d" "/$i"
            # Add our section
            echo "$2" | $DOT_SU tee -a "/$i" > /dev/null
            cat "${DOT_MODULE_DIR}/config-sys/$i" | $DOT_SU tee -a "/$i" > /dev/null
            echo "$3" | $DOT_SU tee -a "/$i" > /dev/null
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Add a section to the beginning of a possibly existing config file.
# If the section exists in the file, it is replaced.
# Args:
#   $1 - Wildcard describing the config files relative to $HOME
#   $2 - Start tag of the section (typically a config file comment)
#   $3 - End tag of the section (typically a config file comment)
dot_prepend_section_to_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in ${DOT_MODULE_DIR}/config/$1
    do
        i=${i#${DOT_MODULE_DIR}/config/}
        if [ -e "${DOT_MODULE_DIR}/config/$i" ]
        then
            mkdir -p $(dirname "${HOME}/$i")
            if [ -e "${HOME}/$i" ] && [ ! -f "${HOME}/$i" ]
            then
                print_error "${HOME}/${i} exists and is not a file!"
                exit 1
            fi
            if [ ! -e "${HOME}/$i" ]
            then # If file does not exist, create it
                touch "${HOME}/$i"
            fi
            # Now remove the old section that might exist
            local safe3=$(printf '%s\n' "$2" | sed 's/[[\.*^$/]/\\&/g')
            local safe4=$(printf '%s\n' "$3" | sed 's/[[\.*^$/]/\\&/g')
            sed -i "/$safe3/,/$safe4/d" "${HOME}/$i"
            # Prepend our section
            local orig_file="$(cat ${HOME}/$i)"
            echo "$2" > "${HOME}/$i"
            cat "${DOT_MODULE_DIR}/config/$i" >> "${HOME}/$i"
            echo "$3" >> "${HOME}/$i"
            echo -n "$orig_file" >> "${HOME}/$i"
            # Prepanding with printf doesn't work since it's considering
            # some characters in the file as formatting characters
            # printf "$2\n$(cat "${DOT_MODULE_DIR}/config/$i")\n$3\n$(cat ${HOME}/$i)\n" > "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


## Install Python 2 PIP module in ~/.local
## Args:
##   $1 - Module name
dot_install_pip2_user()
{
    print_status "Installing $@ for Python 2 in ~/.local"
    if ! dot_inhibit pip install --user --upgrade "$@"
    then
        print_error "Error while running pip!"
        exit 1
    fi
}


## Install Python 3 PIP module in ~/.local
## Args:
##   $1 - Module name
dot_install_pip3_user()
{
    print_status "Installing $@ for Python 3 in ~/.local"
    if ! dot_inhibit pip3 install --user --upgrade "$@"
    then
        print_error "Error while running pip!"
        exit 1
    fi
}


## Install Python 2 PIP module in default location
## Args:
##   $1 - Module name
dot_install_pip2()
{
    print_status "Installing $@ for Python 2 in default location"
    if ! dot_inhibit pip install --upgrade "$@"
    then
        print_error "Error while running pip!"
        exit 1
    fi
}


## Install Python 2 PIP module in default location
## Args:
##   $1 - Module name
dot_install_pip3()
{
    print_status "Installing $@ for Python 3 in default location"
    if ! dot_inhibit pip3 install --upgrade "$@"
    then
        print_error "Error while running pip!"
        exit 1
    fi
}


## Install a Ruby gem in default location
## Args:
##   $1 - Module name
dot_install_gem()
{
    print_status "Installing the Ruby gem $@ in default location"
    if ! dot_inhibit gem install "$@"
    then
        print_error "Error while running gem!"
        exit 1
    fi
}


## Install a Ruby gem in ~/.gem
## Args:
##   $1 - Module name
dot_install_gem_user()
{
    print_status "Installing the Ruby gem $@ in ~/.gem"
    if ! dot_inhibit gem install --user-install "$@"
    then
        print_error "Error while running gem!"
        exit 1
    fi
}


## Install a Node.js package globally
## Args:
##   $1 - Package name
dot_install_npm()
{
    print_status "Installing the Node.js package $@ in default location"
    dot_get_su
    if ! dot_inhibit $DOT_SU npm install -g "$@"
    then
        print_error "Error while running npm!"
        exit 1
    fi
}


## Retrieve updated package list if not yet retrieved
dot_update_package_list()
{
    dot_get_su

    # Update package list the first time we install sth
    if [ -z $DOT_MODULE_PACKAGES_UPDATED ]
    then
        print_status "Retrieving updated list of packages..."
        if ! dot_inhibit $DOT_SU apt-get update
        then
            print_error "Error while running apt-get update!"
            exit 1
        fi
        DOT_MODULE_PACKAGES_UPDATED=1
    fi
}


# Install given system packages
# Currently works only for Debian-based systems.
# Args:
#   $@ - Package names
dot_install_packages()
{
    dot_get_su

    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    # Update package list
    dot_update_package_list
    # Install
    print_status "Installing ${args}..."
    $DOT_SU apt-get install --no-install-recommends $args
}


# Remove given system packages
# Currently works only for Debian-based systems.
# Args:
#   $@ - Package names
dot_remove_packages()
{
    dot_get_su

    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    # Remove
    print_status "Removing ${args}..."
    $DOT_SU apt-get purge $args
}


# Install build dependencies of the given system package
# Currently works only for Debian-based systems.
# Args:
#   $1 - Package name
dot_install_builddep()
{
    dot_get_su

    local pkg=""  # To avoid "bad variable name" in dash for some values
    pkg="$1"
    # Update package list
    dot_update_package_list
    # Install
    print_status "Installing build dependencies of ${pkg}..."
    $DOT_SU apt-get build-dep --no-install-recommends $pkg
}


# Install given Snap packages system-wide
# Args:
#   $@ - Package names
dot_install_snap_packages_sys()
{
    dot_get_su

    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    # Install
    print_status "Installing ${args}..."
    $DOT_SU snap install $args
}


# Clone a git repository (with sub-modules), if it is not yet cloned, and
# checkout a branch or a tag. If the repository is already cloned, fetch
# the origin and update the requested branch or checkout the requested tag.
# WARNING: All local changes to the repo will be overwritten!
# Args:
#   $1 - Path to where it should be cloned
#   $2 - Repo URL
#   $3 - Branch/tag name
dot_git_clone_or_update()
{
    if [ -d "$1/.git" ]
    then
        # Repository exists at this path, check if the origin is correct
        local url=""  # To avoid "bad variable name" in dash for some values
        url=$(git -C "$1" config --get remote.origin.url || true)
        if [ "$url" != "$2" ]
        then
            print_error "The origin of the repo in $1 is different than $2!"
            exit 1
        fi
        # Update
        print_status "Fetching $2..."
        git -C "$1" fetch origin
        if git -C "$1" show-ref -q --verify "refs/tags/$3"
        then
            print_status "Checking out tag $3..."
            git -C "$1" checkout --force "$3"
            git -C "$1" submodule update --recursive
        else
            print_status "Merging branch $3 from $2..."
            git -C "$1" checkout --force "$3"
            git -C "$1" merge origin/"$3"
            git -C "$1" submodule update --recursive
        fi
    else
        print_status "Cloning $3 from $2..."
        if [ -e "$1" ]
        then
            print_error "$1 exists, but is not a git repo!"
            exit 1
        fi
        git clone --recurse-submodules "$2" "$1"
        git -C "$1" checkout --force "$3"
        git -C "$1" submodule update --recursive
    fi
}



## -------------------------------------------------------------
## Checks
## -------------------------------------------------------------

# Check if the current user is root and ask for confirmation.
dot_check_root()
{
    uid="$(id -u)"  # The only way that works with dash
    if [ "$uid" = "0" ] || [ "$HOME" = "/root" ] || [ "$USER" = "root" ] || [ "$(whoami)" = "root" ]
    then
        print_warning "You are running the installation script as root!"
        if ! yes_no_question "Are you sure you want to continue?"
        then
            exit 1
        fi
    fi
}


# Check if Python virtualenv is active and exit if it is the case.
dot_check_virtualenv()
{
    if [ -n "$VIRTUAL_ENV" ]
    then
        print_error "Python VirtualEnv is active. This might interfere with installation!"
        exit 1
    fi
}


# Check if we are on Ubuntu and exit otherwise.
dot_check_ubuntu()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" != "Ubuntu" ]
    then
        print_error "This module can only be installed on Ubuntu!"
        exit 1
    fi
}


# Check if we are on Raspbian and exit otherwise.
dot_check_raspbian()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" != "Raspbian" ]
    then
        print_error "This module can only be installed on Raspbian"
        exit 1
    fi
}


# Check if we are on a Debian derivative and exit otherwise.
dot_check_debian_derivative()
{
    if [ ! -f /etc/debian_version ]
    then
        print_error "This module can only be installed on a Debian derivative!"
        exit 1
    fi
}


# Check if we are on Ubuntu with version >= given.
# Args:
#   $1 - Min Ubuntu version
# Return:
#   $? - 0 if version number >= given, 1 otherwise
dot_is_min_ubuntu_version()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" = "Ubuntu" ]
    then  # On Ubuntu
        cur_ver=$(lsb_release -sr)
        dpkg --compare-versions "$cur_ver" ge "$1"
    else
        return 1
    fi
}


# Check if we are on Ubuntu with version <= given.
# Args:
#   $1 - Max Ubuntu version
# Return:
#   $? - 0 if version number <= given, 1 otherwise
dot_is_max_ubuntu_version()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" = "Ubuntu" ]
    then  # On Ubuntu
        cur_ver=$(lsb_release -sr)
        dpkg --compare-versions "$cur_ver" le "$1"
    else
        return 1
    fi
}


# Check if we are on Debian/Raspbian with version >= given.
# Args:
#   $1 - Min Debian version
# Return:
#   $? - 0 if version number >= given, 1 otherwise
dot_is_min_debian_version()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" = "Debian" ] || [ "$dist_id" = "Raspbian" ]
    then  # On Debian
        cur_ver=$(lsb_release -sr)
        dpkg --compare-versions "$cur_ver" ge "$1"
    else
        return 1
    fi
}


# Check if we are on Debian/Raspbian with version <= given.
# Args:
#   $1 - Max Debian version
# Return:
#   $? - 0 if version number <= given, 1 otherwise
dot_is_max_debian_version()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" = "Debian" ] || [ "$dist_id" = "Raspbian" ]
    then  # On Debian
        cur_ver=$(lsb_release -sr)
        dpkg --compare-versions "$cur_ver" le "$1"
    else
        return 1
    fi
}


# Check if we are on Ubuntu with the given codename.
# Args:
#   $1 - Ubuntu codename, e.g. trusty
# Return:
#   $? - 0 if on the given codename, 1 otherwise
dot_is_ubuntu_codename()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" = "Ubuntu" ]
    then  # On Ubuntu
        [ "$(lsb_release -cs)" = "$1" ]
    else
        return 1
    fi
}


# Check if given system packages are installed.
# If a package is not found, it should be assumed uninstalled.
# Currently works only for Debian-based systems.
# Args:
#   $@ - Package names
# Return:
#   $DOT_NOT_INSTALLED - Not installed packages
#   $? - 1 if something is not installed, 0 otherwise
dot_check_packages()
{
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    DOT_NOT_INSTALLED=""
    DOT_INSTALLED=""
    for pkg in $args
    do
        # We tried several methods of detecting if package is installed before:
        # - dpkg-query -W -f='${Status}' $pkg 2> /dev/null || true
        #   The status values differed between system versions. In Ubuntu 16.04
        #   and in Ubuntu 14.04 the output was different when package was installed
        #   for multiple architectures.
        # - dpkg-query -W -f='${db:Status-Status}' $pkg 2> /dev/null || true
        #   Not available in dpkg-query in Ubuntu 14.04
        status=$(dpkg -l $pkg 2> /dev/null | grep $pkg | awk '$1=="ii" {print $1}' || true)
        if [ -z "$status" ]
        then
            DOT_NOT_INSTALLED=${DOT_NOT_INSTALLED:+${DOT_NOT_INSTALLED} }$pkg
        else
            DOT_INSTALLED=${DOT_INSTALLED:+${DOT_INSTALLED} }$pkg
        fi
    done

    # Return false if sth not installed
    [ -z "$DOT_NOT_INSTALLED" ]
}


# Check if build dependencies of the given package are installed.
# Currently works only for Debian-based systems.
# Note: We intentionally do not run apt-get update first, since
# that would make the checking process very long. We assume that
# this check can only be used for packages in standard repository
# and that the dependencies do not change that much.
# Args:
#   $1 - Package names
# Return:
#   $? - 1 if something is not installed, 0 otherwise
dot_check_builddep()
{
    local pkg=""  # To avoid "bad variable name" in dash for some values
    pkg="$1"
    local ret_val=""
    local ret_code=""
    # Get output from apt-get build-dep simulation
    set +e
    ret_val=$(apt-get build-dep -s $pkg 2>&1)
    ret_code=$?
    set -e
    # Remove anything up till NOTE: which gets in the way with error detection
    ret_val="${ret_val##NOTE: }"
    # Check if package missing
    if [ "$ret_code" != "0" ]
    then
        if [ "${ret_val#*E: }" != "${ret_val}" ]
        then
            print_error "${ret_val#*E: }"
        else
            print_error "Unknown build-dep error!"
        fi
        exit 1
    fi
    # Check if there is anything to install
    ! printf "%s\n" "$ret_val" | grep -q "^Inst "
}


# Check if the given command exists
# Args:
#   $1 - command name
# Return:
#   $? - 0 if exists, 1 otherwise
dot_check_cmd()
{
    # 'type' seems to work as expected in bash/dash/ash(busybox)
    # 'command' does not work in ash/busybox
    if type $1 >/dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}


# Return version of the given package if installed or an empty
# string if not installed. Works on Debian-based distros only
# at this point.
# Args:
#   $1 - package name
# Return:
#   $DOT_PACKAGE_VERSION - version of the installed package
#   $? - 0 if installed, 1 otherwise
dot_get_installed_package_version()
{
    local out=""
    local version=""
    local status=""
    # Note: db:Status-Status is only available in newer dpkg-query, so we use Status
    out=$(dpkg-query -W -f='${Status}|${Version}' "$1" 2> /dev/null || true)
    status=${out%|*}
    status=${status#* * }
    version=${out#*|}
    if [ "$status" = "installed" ] || [ "$status" = "installedinstalled" ]
    then
        DOT_PACKAGE_VERSION=$version
        return 0
    else
        DOT_PACKAGE_VERSION=""
        return 1
    fi
}


# Return version of the given package if available, but not
# necessary installed. Works on Debian-based distros only
# at this point.
# Args:
#   $1 - package name
# Return:
#   $DOT_PACKAGE_VERSION - version of the available package
#   $? - 0 if available, 1 otherwise
dot_get_available_package_version()
{
    DOT_PACKAGE_VERSION=$(apt-cache policy "$1" 2>/dev/null | grep Candidate | sed -e 's/[ ]*Candidate:[ ]*//g')
    [ -n "$DOT_PACKAGE_VERSION" ]
}


# Check if given snap packages are installed.
# If a package is not found, it should be assumed uninstalled.
# Args:
#   $@ - Package names
# Return:
#   $DOT_NOT_INSTALLED - Not installed packages
#   $? - 1 if something is not installed, 0 otherwise
dot_check_snap_packages()
{
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    DOT_NOT_INSTALLED=""
    DOT_INSTALLED=""

    for pkg in $args
    do
        if snap list $pkg >/dev/null 2>&1
        then
            DOT_INSTALLED=${DOT_INSTALLED:+${DOT_INSTALLED} }$pkg
        else
            DOT_NOT_INSTALLED=${DOT_NOT_INSTALLED:+${DOT_NOT_INSTALLED} }$pkg
        fi
    done

    # Return false if sth not installed
    [ -z "$DOT_NOT_INSTALLED" ]
}


# Compare version strings and check if version1 >= version2.
# Currently, works on Debian-based distros only.
# Args:
#   $1 - Version 1
#   $2 - Version 2
# Return:
#   $? - 0 if version1 >= version2, 1 otherwise
dot_versions_ge()
{
    dpkg --compare-versions "$1" ge "$2"
}



## -------------------------------------------------------------
## Other
## -------------------------------------------------------------

# Run parallel build using make and the number of available processors.
dot_parallel_make()
{
    local cpus=""  # To avoid "bad variable name" in dash for some values
    cpus=$(grep -c ^processor /proc/cpuinfo)
    make -j${cpus}
}


# Check if a string contains a substring
# Args:
#   $1 - String
#   $2 - Substring
# Return:
#   $? - 0 if string contains substring, 1 otherwise
dot_contains()
{
    string="$1"
    substring="$2"
    [ "${string#*$substring}" != "$string" ]
}
