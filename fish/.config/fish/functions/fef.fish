function fef
    set dir (or $argv[1] .)
    # --type f: only files
    # --hidden: show dotfiles
    # --follow: follow symlinks (optional, useful for config files)
    # --exclude .git: just to be absolutely safe (though fd ignores it by default)
    set selected_file (fd --type f --hidden --follow --exclude .git . $dir | fzf --preview "bat --style=numbers --color=always {}")

    if test -n "$selected_file"
        nvim $selected_file
    end
end
