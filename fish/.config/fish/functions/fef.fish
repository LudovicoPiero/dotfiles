function fef
    set dir (or $argv[1] .)
    set selected_file (rg --files $dir | fzf --preview "bat --style=numbers --color=always {}")
    if test -n "$selected_file"
        nvim $selected_file
    end
end
