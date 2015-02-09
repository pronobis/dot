#!/bin/bash

## -------------------------------------------------------------
## General
## -------------------------------------------------------------
# Set paths
export DOT_MODULE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ -z "$DOT_DIR" ]
then
   export DOT_DIR=$( readlink -f $DOT_MODULE_DIR/../.. )
fi
TMP_DIR="$DOT_MODULE_DIR/tmp"

# Interrupt the script on first error
set -e

# Import tools
. $DOT_DIR/shell/tools.bash

# Check if run as root
check_root

# Header
print_main_module_header


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
## Finishing
## -------------------------------------------------------------
print_main_module_footer
unset DOT_MODULE_DIR
