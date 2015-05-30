#!/bin/sh

dot_shell=$(cd "${0%/*}/../../shell" && pwd); . "$dot_shell/install_module_header.sh"
check_virtualenv  # Check for virtualenv


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
## Done!
## -------------------------------------------------------------
. "$dot_shell/install_module_footer.sh"
