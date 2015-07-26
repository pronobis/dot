# -*- mode: sh -*-

# Mark that installation has been completed
cd ${DOT_MODULE_DIR}
git rev-parse HEAD > ${DOT_MODULE_DIR}/installed

# Unset "local" vars
unset DOT_MODULE_DIR

# Footer
print_main_module_footer
