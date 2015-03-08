# -*- mode: sh -*-

# Interrupt the script on first error
set -e

# Set paths
export DOT_MODULE_DIR=$( cd "$( dirname "$0" )" && pwd )
if [ -z "$DOT_DIR" ]
then
   export DOT_DIR=$( readlink -f $DOT_MODULE_DIR/../.. )
fi
TMP_DIR="$DOT_MODULE_DIR/tmp"

# Import tools
. "$DOT_DIR/shell/tools.sh"

# Header
print_main_module_header
