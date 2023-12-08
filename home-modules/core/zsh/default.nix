{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.mine.zsh;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.zsh = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable zsh and set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bat
      commitizen
      fd
      fzf
      zoxide
    ];

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";

      history = {
        expireDuplicatesFirst = true;
        path = "${config.xdg.dataHome}/zsh_history";
      };

      initExtra = ''
          # search history based on what's typed in the prompt
          autoload -U history-search-end
          zle -N history-beginning-search-backward-end history-search-end
          zle -N history-beginning-search-forward-end history-search-end
          bindkey "^[OA" history-beginning-search-backward-end
          bindkey "^[OB" history-beginning-search-forward-end

          # case insensitive tab completion
          zstyle ':completion:*' completer _complete _ignored _approximate
          zstyle ':completion:*' list-colors '\'
          zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
          zstyle ':completion:*' menu select
          zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
          zstyle ':completion:*' verbose true
          _comp_options+=(globdots)

        ${lib.optionalString config.services.gpg-agent.enable ''
          gnupg_path=$(ls $XDG_RUNTIME_DIR/gnupg)
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
        ''}
      '';

      dirHashes = {
        cfg = "$HOME/ez"; #FIXME
        docs = "$HOME/Documents";
        vids = "$HOME/Videos";
        dl = "$HOME/Downloads";
      };

      shellAliases =
        let
          _ = lib.getExe;
        in
        with pkgs;
        {
          "c" = "${_ commitizen} commit -- -s"; # Commit with Signed-off
          "cat" = "${_ bat}";
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
          "v" = "nvim";
          "record" = "${_ wl-screenrec} -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
          "record-region" = "${_ wl-screenrec} -g \"$(${_ slurp})\" -f ${config.xdg.userDirs.extraConfig.XDG_RECORD_DIR}/$(date '+%s').mp4";
          "..." = "cd ../..";
          ".." = "cd ..";
        };

      plugins = [
        {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "230695f8da8463b18121f58d748851a67be19a00";
            hash = "sha256-XJl0XVtfi/NTysRMWant84uh8+zShTRwd7t2cxUk+qU=";
          };
        }
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "sindresorhus";
            repo = "pure";
            rev = "87e6f5dd4c793f6d980532205aaefe196780606f";
            hash = "sha256-TR4CyBZ+KoZRs9XDmWE5lJuUXXU1J8E2Z63nt+FS+5w=";
          };
        }
      ];
    };
  };
}
