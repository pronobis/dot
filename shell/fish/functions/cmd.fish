function cmd --description 'Run a bookmarked command'
    if eval $DOT_DIR/scripts/cmd $argv; and [ -d "$DOT_DIR/system" ]
        [ -f "$DOT_DIR/system/setup.all" ]; and source "$DOT_DIR/system/setup.all"
        [ -f "$DOT_DIR/system/setup.fish" ]; and source "$DOT_DIR/system/setup.fish"
    end
end
