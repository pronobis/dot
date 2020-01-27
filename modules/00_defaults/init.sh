#!/bin/sh

dot_shell=$(cd "${0%/*}/../../shell" && pwd); . "$dot_shell/init_module_header.sh"

# This script is run by dot-get after the module is added or updated.
# It can be used to initialize a repository after it is cloned/pulled.
