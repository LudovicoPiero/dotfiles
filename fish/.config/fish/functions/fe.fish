function fe
    set pattern (or $argv[1] "")
    set selected_file (rg --no-heading --line-number "$pattern" | \
        fzf --delimiter : --with-nth 1,2,3 \
            --preview "bat --style=numbers --color=always {1} --highlight-line {2}" )

    if test -n "$selected_file"
        set file (string split -f1 ":" $selected_file)
        set line (string split -f2 ":" $selected_file)
        nvim +$line $file
    end
end
