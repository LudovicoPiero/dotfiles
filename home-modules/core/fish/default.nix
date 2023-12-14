{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.mine.fish;
  _ = lib.getExe;
  inherit (lib) mkIf mkOption types;
  inherit (config.colorscheme) colors;
in {
  imports = [inputs.nix-index-database.hmModules.nix-index];

  options.mine.fish = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable fish Shell and Set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = true;
    programs.zoxide.enable = true;

    programs.fish = with pkgs; {
      enable = true;

      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        fish_greeting = ""; # disable welcome text

        bs = ''
          pushd ~/.config/nixos
          nh os switch .
            if test $status -eq 0
              notify-send "Rebuild Switch" "Build successful!"
            else
              notify-send "Rebuild Switch" "Build failed!"
            end
          popd
        '';

        bb = ''
          pushd ~/.config/nixos
          nh os boot .
            if test $status -eq 0
              notify-send "Rebuild Boot" "Build successful!"
            else
              notify-send "Rebuild Boot" "Build failed!"
            end
          popd
        '';

        hs = ''
          pushd ~/.config/nixos
          nh home switch .
            if test $status -eq 0
              notify-send "Home-Manager Switch" "Build successful!"
            else
              notify-send "Home-Manager Switch" "Build failed!"
            end
          popd
        '';

        fe = ''
          set selected_file (rg --files ''$argv[1] | fzf --preview "bat -f {}")
          if [ -n "$selected_file" ]
              echo "$selected_file" | xargs $EDITOR
          end
        '';

        run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";
        "watchLive" = let
          args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
        in "${_ streamlink} --player ${_ mpv} --twitch-disable-hosting --twitch-low-latency --player-args \"${args}\" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv";
      };

      interactiveShellInit = ''
        set -g async_prompt_functions _pure_prompt_git
        set pure_symbol_prompt "λ"
        set pure_color_success '#${colors.base0E}'

        ${_ any-nix-shell} fish --info-right | source
        ${_ zoxide} init fish | source
        ${_ direnv} hook fish | source
      '';

      shellAliases = {
        "c" = "${_ commitizen} commit -- -s"; # Commit with Signed-off
        "cat" = "${_ bat}";
        "config" = "cd ~/.config/nixos";
        "dla" = "${_ yt-dlp} --extract-audio --audio-format mp3 --audio-quality 0 -P '${config.home.homeDirectory}/Media/Audios'"; # Download Audio
        "dlv" = "${_ yt-dlp} --format 'best[ext=mp4]' -P '${config.home.homeDirectory}/Media/Videos'"; # Download Video
        "ls" = "${_ eza} --icons";
        "l" = "${_ eza} -lbF --git --icons";
        "ll" = "${_ eza} -lbGF --git --icons";
        "llm" = "${_ eza} -lbGF --git --sort=modified --icons";
        "la" = "${_ eza} -lbhHigUmuSa --time-style=long-iso --git --icons";
        "lx" = "${_ eza} -lbhHigUmuSa@ --time-style=long-iso --git --icons";
        "t" = "${_ eza} --tree --icons";
        "tree" = "${_ eza} --tree --icons";
        "lg" = "lazygit";
        "nb" = "nix-build -E \'with import <nixpkgs> { }; callPackage ./default.nix { }\'";
        "nv" = "nvim";
        "nr" = "${_ nixpkgs-review}";
        "mkdir" = "mkdir -p";
        "g" = "git";
        "v" = "vim";
        "record" = "${_ wl-screenrec} -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
        "record-region" = "${_ wl-screenrec} -g \"$(${_ slurp})\" -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
        "..." = "cd ../..";
        ".." = "cd ..";
      };

      plugins = [
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "46c7bc6354494be5d869d56a24a46823a9fdded0";
            hash = "sha256-lxQZo6APemNjt2c21IL7+uY3YVs81nuaRUL7NDMcB6s=";
          };
        }
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "pure-fish";
            repo = "pure";
            rev = "f1b2c7049de3f5cb45e29c57a6efef005e3d03ff";
            hash = "sha256-MnlqKRmMNVp6g9tet8sr5Vd8LmJAbZqLIGoDE5rlu8E=";
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
  };
}
