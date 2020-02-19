# -*- mode: sh -*-

# Interrupt the script on first error
set -e

# Set paths
export DOT_MODULE_DIR=$( cd "${0%/*}" && pwd )
if [ -z "$DOT_DIR" ]
then
   export DOT_DIR=$( cd "$DOT_MODULE_DIR/../.." && pwd )
fi
TMP_DIR="$DOT_MODULE_DIR/tmp"
OPT_DIR="$DOT_MODULE_DIR/opt"

# Import tools
. "$DOT_DIR/shell/tools.sh"

# Reload parameters
__dot_load_params -r

# Header
print_main_module_header
