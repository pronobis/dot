function sys --description "Select a system"
    if eval $DOT_DIR/scripts/sys $argv; and [ -d "$DOT_DIR/system" ]
        [ -f "$DOT_DIR/system/setup.all" ]; and source "$DOT_DIR/system/setup.all"
        [ -f "$DOT_DIR/system/setup.fish" ]; and source "$DOT_DIR/system/setup.fish"
    end
end
