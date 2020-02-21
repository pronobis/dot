# -*- mode: sh -*-

# Interrupt the script on first error
set -e

# Set paths
export DOT_MODULE_DIR=$( cd "${0%/*}" && pwd )
if [ -z "$DOT_DIR" ]
then
   export DOT_DIR=$( cd "$DOT_MODULE_DIR/../.." && pwd )
fi
export TMP_DIR="$DOT_MODULE_DIR/tmp"
export OPT_DIR="$DOT_MODULE_DIR/opt"
export CONFIG_DIR="$DOT_MODULE_DIR/config"
export CONFIG_SYS_DIR="$DOT_MODULE_DIR/config-sys"
export SCRIPTS_DIR="$DOT_MODULE_DIR/scripts"
export BIN_DIR="$DOT_MODULE_DIR/bin"

# Import tools
. "$DOT_DIR/shell/tools.sh"
