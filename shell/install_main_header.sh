# -*- mode: sh -*-

# Interrupt the script on first error
set -e

# Set path to the root .dot dir
DOT_DIR=$( cd "$( dirname "$0" )" && pwd )

# Import tools
. "$DOT_DIR/shell/tools.sh"

# Header
print_main_header
