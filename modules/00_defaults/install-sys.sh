#!/bin/sh

. ${0%/*}/../../shell/install_module_header.sh
check_root  # Check if run as root


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
. ${0%/*}/../../shell/install_module_footer.sh
