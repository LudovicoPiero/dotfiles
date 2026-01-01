function fe
    set pattern $argv[1]

    # Safety: Don't run rg with an empty pattern (it would match every line in every file)
    if test -z "$pattern"
        echo "Usage: fe <pattern>"
        return 1
    end

    # --hidden: Search inside dotfiles (like .config/)
    # --glob '!.git': Explicitly exclude the .git folder
    set selected_file (rg --hidden --glob '!.git' --no-heading --line-number "$pattern" | \
        fzf --delimiter : --with-nth 1,2,3 \
            --preview "bat --style=numbers --color=always {1} --highlight-line {2}" \
            --preview-window "+{2}/2") # Scroll preview to the match line (centered)

    if test -n "$selected_file"
        # Split safely: limit to 2 splits to handle filenames with colons correctly
        set parts (string split -m 2 ":" $selected_file)
        set file $parts[1]
        set line $parts[2]

        nvim +$line $file
    end
end
