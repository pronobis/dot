# -*- mode: sh -*-

# Include guard
[ -n "$DOT_SETUP_TOOLS" ] && return || readonly DOT_SETUP_TOOLS=1


## -------------------------------------------------------------
## Printing
## -------------------------------------------------------------

# Include formatting
. "$DOT_DIR/shell/formatting.sh"


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
    set_format ${LIGHT_GREEN}
    printf "$1\n" "$2"
    clear_format
}

print_warning()
{
    set_format ${YELLOW}
    printf "WARNING: $1\n" "$2"
    clear_format
}

print_error()
{
    set_format ${LIGHT_RED}
    printf "ERROR: $1\n" "$2" 1>&2
    clear_format
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


## -------------------------------------------------------------
## Installing
## -------------------------------------------------------------
# Create a link to a given binary
# Args:
#   $1 - Dot root dir
#   $2 - Path to the bin file relative to the dot root dir
dot_link_bin()
{
    if [ -d "$1/bin" ]
    then
        if [ -x $1/$2 ]
        then
           ln -sf "$1/$2" "$1/bin"
        else
            print_error "File $2 is not executable or does not exist!"
            exit 1
        fi
    else
        print_error "No bin folder!"
        exit 1
    fi
}


# Create a link to config files
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
dot_link_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
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
dot_link_config_sys()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config-sys/$2
    do
        i=${i#$1/config-sys/}
        if [ -e "$1/config-sys/$i" ]
        then
            sudo mkdir -p $(dirname "/$i")
            if sudo test -d "/$i" && sudo test ! -L "/$i"
            then # Do not overwrite existing folders
                print_error "/${i} already exists and is a directory!"
                exit 1
            fi
            if sudo test -e "/$i" || sudo test -h "/$i"
            then # To prevent creation of a link on another link (e.g. link to folder)
                sudo rm "/$i"
            fi
            sudo ln -s "$1/config-sys/$i" "/$i"
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
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $HOME/$1
    do
        i=${i#$HOME/}
        if [ -e "$HOME/$i" ]
        then
            sudo mkdir -p $(dirname "/root/$i")
            if sudo test -d "/root/$i" && sudo test ! -L "/root/$i"
            then # Do not overwrite existing folders
                print_error "/root/${i} already exists and is a directory!"
                exit 1
            fi
            if sudo test -e "/root/$i" || sudo test -h "/root/$i"
            then # To prevent creation of a link on another link (e.g. link to folder)
                sudo rm "/root/$i"
            fi
            sudo ln -s "$HOME/$i" "/root/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}



# Make a copy of config files
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
dot_copy_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
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
            cp -d "$1/config/$i" "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Make a copy of config files system-wide
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
dot_copy_config_sys()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config-sys/$2
    do
        i=${i#$1/config-sys/}
        if [ -e "$1/config-sys/$i" ]
        then
            sudo mkdir -p $(dirname "/$i")
            if sudo test -d "/$i" && sudo test ! -L "/$i"
            then # Do not overwrite existing folders
                print_error "/${i} already exists and is a directory!"
                exit 1
            fi
            if sudo test -e "/$i" || sudo test -h "/$i"
            then # To prevent copying into a link
                sudo rm "/$i"
            fi
            sudo cp -d "$1/config-sys/$i" "/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Copy config files and fill env. variables inside
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to $HOME
dot_fill_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
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
            # envsubst < "$1/config/$i" > "${HOME}/$i"  # Does not work with busybox
            sed \
                -e 's#${HOME}#'"${HOME}"'#' \
                -e 's#${DOT_DIR}#'"${DOT_DIR}"'#' \
                -e 's#${DOT_MODULE_DIR}#'"${DOT_MODULE_DIR}"'#' \
                "$1/config/$i" > "${HOME}/$i"
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Copy system-wide config files and fill env. variables inside
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the path to config files relative to /
dot_fill_config_sys()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config-sys/$2
    do
        i=${i#$1/config-sys/}
        if [ -e "$1/config-sys/$i" ]
        then
            sudo mkdir -p $(dirname "/$i")
            if sudo test -d "/$i" && sudo test ! -L "/$i"
            then # Do not overwrite existing folders
                print_error "/${i} already exists and is a directory!"
                exit 1
            fi
            if sudo test -e "/$i" || sudo test -h "/$i"
            then # To prevent copying into a link
                sudo rm "/$i"
            fi
            # envsubst < "$1/config-sys/$i" > "/$i"  # Does not work with busybox
            sed \
                -e 's#${HOME}#'"${HOME}"'#' \
                -e 's#${DOT_DIR}#'"${DOT_DIR}"'#' \
                -e 's#${DOT_MODULE_DIR}#'"${DOT_MODULE_DIR}"'#' \
                "$1/config-sys/$i" | sudo tee "/$i" > /dev/null
        else
            print_warning "No config file $i found!"
        fi
    done
}


# Append to the end of a possibly existing config file.
# Args:
#   $1 - Dot root dir
#   $2 - Wildcard describing the config files relative to $HOME
dot_append_to_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
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
            cat "$1/config/$i" >> "${HOME}/$i"
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
dot_append_section_to_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
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
dot_prepend_section_to_config()
{
    local IFS="$(printf '\n+')"; IFS=${IFS%+}  # Only this is dash/ash compatible
    for i in $1/config/$2
    do
        i=${i#$1/config/}
        if [ -e "$1/config/$i" ]
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
            local safe3=$(printf '%s\n' "$3" | sed 's/[[\.*^$/]/\\&/g')
            local safe4=$(printf '%s\n' "$4" | sed 's/[[\.*^$/]/\\&/g')
            sed -i "/$safe3/,/$safe4/d" "${HOME}/$i"
            # Add our section
            printf "$3\n$(cat "$1/config/$i")\n$4\n$(cat ${HOME}/$i)\n" > "${HOME}/$i"
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
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    print_status "Installing ${args} for Python 2 in ~/.local"
    set +e
    out=$(pip2 install --user --upgrade $args 2>&1)
    if [ $? -ne 0 ]
    then
        printf "%s\n" "$out"
        print_error "Error while running pip!"
        exit 1
    fi
    set -e
}


# ## Install Python 2 PIP module in ~/.local only if it's not in latest version already
# ## Args:
# ##   $1 - Module name
# dot_update_pip2_user()
# {
#     local pkg=""  # To avoid "bad variable name" in dash for some values
#     pkg="$@"
#     if dot_check_pip2_latest_user "$pkg"
#     then
#         print_status "${pkg} is installed in latest version $PIP_PACKAGE_VERSION_INSTALLED"
#     else
#         dot_install_pip2_user "$pkg"
#     fi
# }


## Install Python 3 PIP module in ~/.local
## Args:
##   $1 - Module name
dot_install_pip3_user()
{
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    print_status "Installing ${args} for Python 3 in ~/.local"
    set +e
    out=$(pip3 install --user --upgrade $args 2>&1)
    if [ $? -ne 0 ]
    then
        printf "%s\n" "$out"
        print_error "Error while running pip!"
        exit 1
    fi
    set -e
}


# ## Install Python 3 PIP module in ~/.local only if it's not in latest version already
# ## Args:
# ##   $1 - Module name
# dot_update_pip3_user()
# {
#     local pkg=""  # To avoid "bad variable name" in dash for some values
#     pkg="$@"
#     if dot_check_pip3_latest_user "$pkg"
#     then
#         print_status "${pkg} is installed in latest version $PIP_PACKAGE_VERSION_INSTALLED"
#     else
#         dot_install_pip3_user "$pkg"
#     fi
# }


## Install Python 2 PIP module in default location
## Args:
##   $1 - Module name
dot_install_pip2()
{
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    print_status "Installing ${args} for Python 2 in default location"
    set +e
    out=$( pip2 install --upgrade $args 2>&1)
    if [ $? -ne 0 ]
    then
        printf "%s\n" "$out"
        print_error "Error while running pip!"
        exit 1
    fi
    set -e
}


## Install Python 2 PIP module in default location
## Args:
##   $1 - Module name
dot_install_pip3()
{
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    print_status "Installing ${args} for Python 3 in default location"
    set +e
    out=$(pip3 install --upgrade $args 2>&1)
    if [ $? -ne 0 ]
    then
        printf "%s\n" "$out"
        print_error "Error while running pip!"
        exit 1
    fi
    set -e
}


# Install given system packages
# Currently works only for Debian-based systems.
# Args:
#   $@ - Package names
dot_install_packages()
{
    local args=""  # To avoid "bad variable name" in dash for some values
    args="$@"
    # Update package list the first time we install sth
    if [ -z $DOT_MODULE_PACKAGES_UPDATED ]
    then
        print_status "Retrieving updated list of packages..."
        set +e
        out=$(sudo apt-get update 2>&1)
        if [ $? -ne 0 ]
        then
            printf "%s\n" "$out"
            print_error "Error while running apt-get update!"
            exit 1
        fi
        DOT_MODULE_PACKAGES_UPDATED=1
        set -e
    fi
    # Install
    print_status "Installing ${args}..."
    sudo apt-get install -y --no-install-recommends $args
}


# Install build dependencies of the given system package
# Currently works only for Debian-based systems.
# Args:
#   $1 - Package name
dot_install_builddep()
{
    local pkg=""  # To avoid "bad variable name" in dash for some values
    pkg="$1"
    # Update package list the first time we install sth
    if [ -z $DOT_MODULE_PACKAGES_UPDATED ]
    then
        print_status "Retrieving updated list of packages..."
        set +e
        out=$(sudo apt-get update 2>&1)
        if [ $? -ne 0 ]
        then
            printf "%s\n" "$out"
            print_error "Error while running apt-get update!"
            exit 1
        fi
        DOT_MODULE_PACKAGES_UPDATED=1
        set -e
    fi
    # Install
    print_status "Installing build dependencies of ${pkg}..."
    sudo apt-get build-dep -y --no-install-recommends $pkg
}



## -------------------------------------------------------------
## Checks
## -------------------------------------------------------------

# Check if the user is root
dot_check_root()
{
    uid="$(id -u)"  # The only way that works with dash
    if [ "$HOME" != "/root" ] || [ "$USER" != "root" ] || [ "$uid" != "0" ]
    then
        print_error "This script must be run as root!"
        exit 1
    fi
}

# Check if the user is root
dot_check_not_root()
{
    uid="$(id -u)"  # The only way that works with dash
    if [ "$uid" = "0" ] || [ "$HOME" = "/root" ] || [ "$USER" = "root" ] || [ "$(whoami)" = "root" ]
    then
        print_error "This script should not be run as root!"
        exit 1
    fi
}


# Check if the user is root
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


# Check if virtualenv is active
dot_check_virtualenv()
{
    if [ -n "$VIRTUAL_ENV" ]
    then
        print_error "Python VirtualEnv is active. This might interfere with installation!"
        exit 1
    fi
}


# Check if on Ubuntu
dot_check_ubuntu()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" != "Ubuntu" ]
    then
        print_error "This module can only be installed on Ubuntu!"
        exit 1
    fi
}


# Return true if on Ubuntu with version at least ver
dot_is_min_ubuntu_version()
{
    dist_id=$(lsb_release -si 2>/dev/null || true)
    if [ "$dist_id" = "Ubuntu" ]
    then  # On Ubuntu
        cur_ver=$(lsb_release -sr)
        [ "$(echo "$cur_ver >= $1" | bc -l)" = "1" ]
    else
        return 1
    fi
}


# Check if given system packages are installed.
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
    for pkg in $args
    do
        status=$(dpkg-query -W -f='${db:Status-Status}' $pkg 2> /dev/null || true)
        # Check if package missing
        # This is disabled since dpkg-query is not aware of uninstalled packages
        # that are not in the dependencies of any installed package. If detecting
        # missing packages becomes important, apt-cache should be used for that.
        # if [ -z "$status" ]
        # then
        #     print_error "Package $pkg not found!"
        #     exit 1
        # fi
        # Check if package installed
        if [ "$status" != "installed" ]
        then
            DOT_NOT_INSTALLED=${DOT_NOT_INSTALLED:+${DOT_NOT_INSTALLED} }$pkg
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
    ret_val=$(apt-get build-dep -s $pkg 2>/dev/null)
    ret_code=$?
    set -e
    # Check if package missing
    if [ "$ret_code" != "0" ]
    then
        print_error "Package $pkg not found!"
        exit 1
    fi
    # Check if there is anything to install
    ! printf "%s\n""$ret_val" | grep -q "^Inst "
}

# # Check if the pip installed package in ~/.local is in the latest version
# # Args:
# #   $1 - Package name
# # Return:
# #   PIP_PACKAGE_VERSION_INSTALLED - the installed version of the package
# #   PIP_PACKAGE_VERSION_LATEST - the latest version of the package
# #   $? - 0 if latest is installed, 1 otherwise
# dot_check_pip2_latest_user()
# {
#     local pkg=""  # To avoid "bad variable name" in dash for some values
#     pkg="$1"

#     # Get latest version
#     PIP_PACKAGE_VERSION_LATEST=$(wget -qO- "https://pypi.python.org/pypi/${pkg}/json" | awk '/"version":/{gsub(/"|,/,"",$2); print $2}')

#     # Get installed info
#     local tmp=""
#     tmp=$(pip2 show "$pkg")

#     # Check if installed in user location
#     local pkg_path=""
#     pkg_path=$(printf "%s" "$tmp" | grep "Location:")
#     pkg_path=${pkg_path#Location: }
#     if [ "${pkg_path#${HOME}/.local}" = "$pkg_path" ]
#     then
#         PIP_PACKAGE_VERSION_INSTALLED=""
#         return 1
#     fi

#     # Get installed version
#     PIP_PACKAGE_VERSION_INSTALLED=$(printf "%s" "$tmp" | grep "Version:")
#     PIP_PACKAGE_VERSION_INSTALLED=${PIP_PACKAGE_VERSION_INSTALLED#Version: }

#     # Compare versions
#     [ "$PIP_PACKAGE_VERSION_INSTALLED" = "$PIP_PACKAGE_VERSION_LATEST" ]
# }


# # Check if the pip installed package in ~/.local is in the latest version
# # Args:
# #   $1 - Package name
# # Return:
# #   PIP_PACKAGE_VERSION_INSTALLED - the installed version of the package
# #   PIP_PACKAGE_VERSION_LATEST - the latest version of the package
# #   $? - 0 if latest is installed, 1 otherwise
# dot_check_pip3_latest_user()
# {
#     local pkg=""  # To avoid "bad variable name" in dash for some values
#     pkg="$1"

#     # Get latest version
#     PIP_PACKAGE_VERSION_LATEST=$(wget -qO- "https://pypi.python.org/pypi/${pkg}/json" | awk '/"version":/{gsub(/"|,/,"",$2); print $2}')

#     # Get installed info
#     local tmp=""
#     tmp=$(pip3 show "$pkg")

#     # Check if installed in user location
#     local pkg_path=""
#     pkg_path=$(printf "%s" "$tmp" | grep "Location:")
#     pkg_path=${pkg_path#Location: }
#     if [ "${pkg_path#${HOME}/.local}" = "$pkg_path" ]
#     then
#         PIP_PACKAGE_VERSION_INSTALLED=""
#         return 1
#     fi

#     # Get installed version
#     PIP_PACKAGE_VERSION_INSTALLED=$(printf "%s" "$tmp" | grep "Version:")
#     PIP_PACKAGE_VERSION_INSTALLED=${PIP_PACKAGE_VERSION_INSTALLED#Version: }

#     # Compare versions
#     [ "$PIP_PACKAGE_VERSION_INSTALLED" = "$PIP_PACKAGE_VERSION_LATEST" ]
# }
