function mkcd
    mkdir -p $argv[1]
    if test -d "$argv[1]"
        cd $argv[1]
    end
end
