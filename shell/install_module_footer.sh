# -*- mode: sh -*-

# Mark that installation has been completed
cd ${TMP_DIR}
git rev-parse HEAD > ${TMP_DIR}/installed

# Unset exported "local" vars
unset DOT_MODULE_DIR

# Footer
print_main_module_footer
