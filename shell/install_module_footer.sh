# -*- mode: sh -*-

# Mark that installation has been completed
dot_get_git
cd ${TMP_DIR}
$DOT_GIT rev-parse HEAD > ${TMP_DIR}/installed

# Unset exported "local" vars
unset DOT_MODULE_DIR

# Footer
print_main_module_footer
