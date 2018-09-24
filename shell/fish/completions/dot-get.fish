complete -c dot-get -x  # No completions initially
complete -c dot-get -n '__fish_use_subcommand' -xa list -d 'List all modules'  # Add subcommand if none given
complete -c dot-get -n '__fish_use_subcommand' -xa status -d 'Show module status'
complete -c dot-get -n '__fish_use_subcommand' -xa add -d 'Add a new module'
complete -c dot-get -n '__fish_use_subcommand' -xa update -d 'Update a module'
complete -c dot-get -n '__fish_use_subcommand' -xa resolve -d 'Resolve missing deps'
complete -c dot-get -n '__fish_use_subcommand' -a install -d 'Install a module'
# - Add list of modules to install/update if subcommand is install/update and module is not yet provided (only 2 cmds in cmd line)
complete -c dot-get -n '__fish_seen_subcommand_from update; and test (__fish_number_of_cmd_args_wo_opts) = 2' -xa 'all' -d 'All modules'
complete -c dot-get -n '__fish_seen_subcommand_from update; and test (__fish_number_of_cmd_args_wo_opts) = 2' -xa 'dot' -d 'Dot itself'
complete -c dot-get -n '__fish_seen_subcommand_from update install; and test (__fish_number_of_cmd_args_wo_opts) = 2' -xa '(__dot_get_modules)'
