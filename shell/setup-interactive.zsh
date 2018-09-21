# -*- mode: sh -*-
## ----------------------------------------------------------
## Executed for interactive login and non-login
## ZSH sessions.
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_SETUP_INTERACTIVE_ZSH" ] && return || readonly DOT_SETUP_INTERACTIVE_ZSH=1


# Run setup-interactive.zsh in all modules
if [ -d "$DOT_DIR/modules" ]
then
    for i in `ls $DOT_DIR/modules | sort`; do
        i="$DOT_DIR/modules/$i"
        if [ -d "$i" ]
        then
            # Run the in each module
            if [ -f "$i/shell/setup-interactive.zsh" ]
            then
                DOT_MODULE_DIR="$i"
                . "$i/shell/setup-interactive.zsh"
                unset DOT_MODULE_DIR
            fi
        fi
    done
fi

# Setup selected system
if [ -d "$DOT_DIR/system" ] && [ -f "$DOT_DIR/system/setup.zsh" ]
then
    . "$DOT_DIR/system/setup.zsh"
fi

# Add completion for dot-get (not yet converted to ZSH)
# __dot_dotget_completion()
# {
#     local cur prev
#     COMPREPLY=()
#     cur="${COMP_WORDS[COMP_CWORD]}"
#     prev="${COMP_WORDS[COMP_CWORD-1]}"

#     case "${prev}" in
#         dot-get)
#             local options="add install list status update"
#             COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
#             return 0
#             ;;
#         update)
#             local DOT_MODULES
#             __dot_get_modules
#             DOT_MODULES="${DOT_MODULES:+${DOT_MODULES}:}:all:dot"
#             COMPREPLY=( $(compgen -W "${DOT_MODULES//:/ }" -- ${cur}) )
#             return 0
#             ;;
#         install)
#             local DOT_MODULES
#             __dot_get_modules
#             COMPREPLY=( $(compgen -W "${DOT_MODULES//:/ }" -- ${cur}) )
#             return 0
#             ;;
#         *)
#             ;;
#     esac
# }
# complete -F __dot_dotget_completion dot-get
