{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  _ = lib.getExe;
in {
  imports = [inputs.nix-index-database.hmModules.nix-index];

  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.zoxide.enable = true;

  programs.fish = with pkgs; {
    enable = true;
    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      fish_greeting = ""; # disable welcome text
      run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";

      bs = ''
        pushd ~/Media/nixos
        ${lib.getExe pkgs.nh} os switch .
          if test $status -eq 0
            notify-send "Rebuild Switch" "Build successful!"
          else
            notify-send "Rebuild Switch" "Build failed!"
          end
        popd
      '';

      bb = ''
        pushd ~/Media/nixos
        ${lib.getExe pkgs.nh} os boot .
          if test $status -eq 0
            notify-send "Rebuild Boot" "Build successful!"
          else
            notify-send "Rebuild Boot" "Build failed!"
          end
        popd
      '';

      hs = ''
        pushd ~/Media/nixos
        ${lib.getExe pkgs.nh} home switch .
          if test $status -eq 0
            notify-send "Home-Manager Switch" "Build successful!"
          else
            notify-send "Home-Manager Switch" "Build failed!"
          end
        popd
      '';

      fe = ''
        set selected_file (${lib.getExe' ripgrep "rg"} --files $argv[1] | fzf --preview "${_ bat} -f {}")
        if [ -n "$selected_file" ]
            echo "$selected_file" | xargs $EDITOR
        end
      '';

      paste = ''
        # https://github.com/ptr1337/dotfiles/blob/master/scripts/misc/paste-cachyos
        set URL "https://paste.cachyos.org"

        set FILEPATH $argv[1]
        set FILENAME (basename -- $FILEPATH)
        set EXTENSION (string match -r '\.(.*)$' $FILENAME; and echo $argv[1] ; or echo "")

        set RESPONSE (curl --data-binary @$FILEPATH --url $URL)
        set PASTELINK "$URL$RESPONSE"

        if test -z "$EXTENSION"
            echo "$PASTELINK"
        else
            echo "$PASTELINK$EXTENSION"
        end
      '';

      "watchLive" = let
        args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
      in ''${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args "${args}" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv'';
    };

    shellAliases = {
      "cat" = "${_ bat}";
      "config" = "cd ~/Media/nixos";
      "dla" = "${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P '${config.home.homeDirectory}/Media/Audios'"; # Download Audio
      "dlv" = "${_ yt-dlp} --format 'best[ext=mp4]' -P '${config.home.homeDirectory}/Media/Videos'"; # Download Video
      "ls" = "${_ lsd}";
      "ll" = "${_ lsd} -l";
      "la" = "${_ lsd} -A";
      "lt" = "${_ lsd} --tree";
      "lla" = "${_ lsd} -lA";
      "t" = "${_ lsd} -l --tree";
      "tree" = "${_ lsd} -l --tree";
      "lg" = "${_ lazygit}";
      "nb" = "nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'";
      "nv" = "nvim";
      "nr" = "${_ nixpkgs-review}";
      "mkdir" = "mkdir -p";
      # "sudo" = "doas";
      "g" = "git";
      "v" = "vim";
      "record" = "${_ wl-screenrec} -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
      "record-region" = ''${_ wl-screenrec} -g "$(${_ slurp})" -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4'';
      "y" = "${_ yazi}";
      "..." = "cd ../..";
      ".." = "cd ..";
    };

    interactiveShellInit = let
      inherit (config.colorScheme) palette;
    in ''
      set -g async_prompt_functions _pure_prompt_git
      set pure_symbol_prompt "❯"
      set pure_color_success '#${palette.base0E}'

      ${_ any-nix-shell} fish --info-right | source
      ${_ zoxide} init fish | source
      ${_ direnv} hook fish | source
    '';

    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "e5d54b93cd3e096ad6c2a419df33c4f50451c900";
          hash = "sha256-5cO5Ey7z7KMF3vqQhIbYip5JR6YiS2I9VPRd6BOmeC8=";
        };
      }
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "pure-fish";
          repo = "pure";
          rev = "d9c241c3a168a13aa37c177be6cd8475dc4679ea";
          hash = "sha256-TDDCNQQk6zOkPdUXJmgnzn8NueSA5nlAJ2OpfhFoFeY=";
        };
      }
      {
        name = "fish-async-prompt";
        src = pkgs.fetchFromGitHub {
          owner = "acomagu";
          repo = "fish-async-prompt";
          rev = "4c732cc043b8dd04e64a169ec6bbf3a9b394819f";
          hash = "sha256-YgqZINmY4nKphlqwHo2B0NfP4nmSxIIuAMUuoftI9Lg=";
        };
      }
    ];
  };
}
