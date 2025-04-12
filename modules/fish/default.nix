{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalString;

  _ = lib.getExe;
  __ = lib.getExe';

  cfg = config.myOptions.fish;
in
{
  imports = [ ./shellAliases.nix ];

  options.myOptions.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };

    environment.pathsToLink = [ "/share/fish" ];

    users.users.root.shell = pkgs.fish;
    users.users.${config.vars.username}.shell = pkgs.fish;
    programs = {
      zoxide.enable = true;
      fish = {
        enable = true;
        interactiveShellInit =
          with pkgs;
          ''
            . ${config.sops.secrets."shells/githubToken".path}

            function gitignore
                curl -sL https://www.gitignore.io/api/$argv
            end

            function run
                ${_ config.nix.package} run nixpkgs#$argv[1] -- $argv[2..-1]
            end

            function ,
                ${_ config.nix.package} run nixpkgs#$argv[1]
            end

            function ns
                ${_ config.nix.package} shell nixpkgs#$argv[1]
            end

            function y
                set tmp (mktemp -t "yazi-cwd.XXXXXX")
                ${_ yazi} $argv --cwd-file="$tmp"
                if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
                    builtin cd -- "$cwd"
                end
                rm -f -- "$tmp"
            end

            function bs
                pushd /home/${config.vars.username}/Code/nixos
                ${_ nh} os switch .

                if test $status -eq 0
                    ${__ libnotify "notify-send"} "Rebuild Switch" "Build successful!"
                else
                    ${__ libnotify "notify-send"} "Rebuild Switch" "Build failed!"
                end

                popd
            end

            function bb
                pushd /home/${config.vars.username}/Code/nixos
                ${_ nh} os boot .

                if test $status -eq 0
                    ${__ libnotify "notify-send"} "Rebuild Boot" "Build successful!"
                else
                    ${__ libnotify "notify-send"} "Rebuild Boot" "Build failed!"
                end

                popd
            end

            function clean-all
                ${_ nh} clean all

                if test $status -eq 0
                    ${__ libnotify "notify-send"} "NH Clean All" "Clean successful!"
                else
                    ${__ libnotify "notify-send"} "NH Clean All" "Clean failed!"
                end
            end

            function fe
                set selected_file (${__ ripgrep "rg"} --files $argv[1] | fzf --preview "${_ bat} -f {}")
                if test -n "$selected_file"
                    echo "$selected_file" | xargs ${config.environment.sessionVariables.EDITOR}
                end
            end

            function paste
                set URL "https://paste.cachyos.org"

                set FILEPATH $argv[1]
                set FILENAME (basename -- $FILEPATH)
                set EXTENSION (string match -r '\.(.*)$' $FILENAME; and echo $argv[1]; or echo "")

                set RESPONSE (curl --data-binary @$FILEPATH --url $URL)
                set PASTELINK "$URL$RESPONSE"

                if test -z "$EXTENSION"
                    echo "$PASTELINK"
                else
                    echo "$PASTELINK$EXTENSION"
                end
            end

            function watchLive
                if test (count $argv) -ge 2
                    set quality $argv[2]
                else
                    set quality "best"
                end

                ${_ streamlink} --player ${_ mpv} $argv[1] $quality
            end

            function mkcd
                ${__ uutils-coreutils-noprefix "mkdir"} -p $argv[1]
                if test -d "$argv[1]"
                    cd $argv[1]
                end
            end

            function extract
                switch "$argv[1]"
                    case '*.tar.bz2'
                        ${__ gnutar "tar"} xvjf "$argv[1]"
                    case '*.tar.gz'
                        ${__ gnutar "tar"} xvzf "$argv[1]"
                    case '*.bz2'
                        ${__ bzip2 "bunzip2"} "$argv[1]"
                    case '*.rar'
                        ${_ unrar} x "$argv[1]"
                    case '*.gz'
                        ${__ gzip "gunzip"} "$argv[1]"
                    case '*.tar'
                        ${__ gnutar "tar"} xvf "$argv[1]"
                    case '*.tbz2'
                        ${__ gnutar "tar"} xvjf "$argv[1]"
                    case '*.tgz'
                        ${__ gnutar "tar"} xvzf "$argv[1]"
                    case '*.zip'
                        ${_ unzip} "$argv[1]"
                    case '*.Z'
                        ${__ gzip "uncompress"} "$argv[1]"
                    case '*.7z'
                        ${__ p7zip "7z"} x "$argv[1]"
                    case '*'
                        echo "Cannot extract '$argv[1]' via extract"
                end
            end
          ''
          +
            optionalString (!config.vars.withGui && config.vars.isALaptop)
              # Automatically turn off screen after 1 minute. (For laptop)
              ''
                ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
              '';
      };
    };
  };
}
