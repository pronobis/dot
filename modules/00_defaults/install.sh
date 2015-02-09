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

# Check if not run as root
check_not_root

# Header
print_main_module_header


## -------------------------------------------------------------
## Installation
## -------------------------------------------------------------

## -------------------------------------------------------------
print_header "Creating links to binaries"
# dot_link_bin $DOT_MODULE_DIR "scripts/display-manager"
print_status "Done!"

## -------------------------------------------------------------
print_header "Installing user-local config files"
# dot_link_config $DOT_MODULE_DIR ".selected_editor"
# dot_append_to_config $DOT_MODULE_DIR ".ssh/config" "# dot-module-default configuration begins here" "# dot-module-default configuration ends here"
# dot_fill_config $DOT_MODULE_DIR ".config/mc/ini" # Fill the ini file with $HOME path
# dot_copy_config $DOT_MODULE_DIR ".aspell.en.pws"
print_status "Done!"


## -------------------------------------------------------------
## Finishing
## -------------------------------------------------------------
print_main_module_footer
unset DOT_MODULE_DIR
