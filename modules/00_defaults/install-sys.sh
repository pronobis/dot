#!/bin/sh

dot_shell=$(cd "${0%/*}/../../shell" && pwd); . "$dot_shell/install_module_header.sh"
check_root  # Check if run as root
check_virtualenv  # Check for virtualenv


## -------------------------------------------------------------
## Installation
## -------------------------------------------------------------

## -------------------------------------------------------------
print_header "Installing Ubuntu packages"
# apt-get install gettext-base
print_status "Done!"

## -------------------------------------------------------------
print_header "Installing system-wide config files"
# dot_link_config_sys $DOT_MODULE_DIR "etc/X11/xorg.conf"
# dot_fill_config_sys $DOT_MODULE_DIR "usr/share/sddm/scripts/Xsetup"
print_status "Done!"


## -------------------------------------------------------------
## Done!
## -------------------------------------------------------------
. "$dot_shell/install_module_footer.sh"
