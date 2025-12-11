# ~/.config/fish/completions/c.fish
# Fixes slow completion for the bare git 'c' alias

function __fish_c_complete_add
    # Use standard file completion for 'c add'
    __fish_complete_subcommand
end

# Define a completion rule for the 'c' command
complete -c c -a add -x -f -k -n '__fish_c_complete_add'
