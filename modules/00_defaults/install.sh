#!/bin/sh

dot_shell=$(cd "${0%/*}/../../shell" && pwd); . "$dot_shell/install_module_header.sh"
dot_check_root # Check if we run as root
# dot_check_ubuntu  # Are we on Ubuntu?
dot_check_virtualenv  # Check for virtualenv


## -------------------------------------------------------------
## Installation
## -------------------------------------------------------------

print_warning "This is just an example that does nothing!"

## -------------------------------------------------------------
# print_header "Installing some packages"
# if dot_check_packages build-essential cmake cmake-curses-gui ccache
# then
#     print_status "All packages are already installed."
# else
#     if yes_no_question "Install packages: $DOT_NOT_INSTALLED?"
#     then
#         dot_install_packages $DOT_NOT_INSTALLED
#         print_status "Done!"
#     fi
# fi


## -------------------------------------------------------------
# print_header "Creating links to binaries"
# dot_link_bin $DOT_MODULE_DIR "scripts/my-binary"
# print_status "Done!"


## -------------------------------------------------------------
# print_header "Installing user-local config files"
# dot_link_config $DOT_MODULE_DIR ".local/share/icons/*"
# dot_copy_config $DOT_MODULE_DIR ".kde/share/config/digikamrc"
# print_status "Done!"


## -------------------------------------------------------------
# print_header "Installing system-wide config files"
# dot_link_config_sys $DOT_MODULE_DIR "etc/default/crda"
# dot_copy_config_sys $DOT_MODULE_DIR "usr/lib/pm-utils/power.d/powertop_toggables"
# dot_fill_config_sys $DOT_MODULE_DIR "usr/share/sddm/scripts/Xsetup"
# Done
# print_status "Done!"


## -------------------------------------------------------------
## Done!
## -------------------------------------------------------------
. "$dot_shell/install_module_footer.sh"
