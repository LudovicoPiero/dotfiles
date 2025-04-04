{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalString;

  cfg = config.myOptions.zsh;
in
{
  options.myOptions.zsh = {
    enable = mkEnableOption "zsh Shell";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.myOptions.fish.enable;
        message = "zsh and fish can't be enabled at the same time";
      }
    ];

    # Nixos Options
    users.users.${config.vars.username}.shell = pkgs.zsh;
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };

    environment.pathsToLink = [ "/share/zsh" ];

    programs = {
      zsh = {
        enable = true; # This settings comes from nixos options
        enableCompletion = false; # Enable it inside home-manager
        interactiveShellInit =
          ''
            . ${config.sops.secrets."shells/githubToken".path}
          ''
          +
            optionalString (!config.vars.withGui && config.vars.isALaptop)
              # Automatically turn off screen after 1 minute. (For laptop)
              ''
                ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
              '';
      };
    };

    home-manager.users."${config.vars.username}" = {
      home.packages = lib.attrValues {
        inherit (pkgs)
          zoxide
          fzf
          fd
          bat
          lazygit
          ;
      };

      imports = [
        ./shellAliases.nix
        ./initExtra.nix
      ];

      programs = {
        zoxide.enable = true;
        zsh = {
          enable = true;
          enableCompletion = true;
          autocd = true;
          defaultKeymap = "emacs";
          dotDir = ".config/zsh";

          initExtraFirst = ''
            # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
            # Initialization code that may require console input (password prompts, [y/n]
            # confirmations, etc.) must go above this block; everything else may go below.
            if [[ -r ''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh ]] {
              source ''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh
            }
          '';

          autosuggestion = {
            enable = true;
            strategy = [
              "history"
              "completion"
              "match_prev_cmd"
            ];
          };

          syntaxHighlighting = {
            enable = true;
            highlighters = [
              "main"
              "brackets"
              "pattern"
            ];
            patterns = {
              "rm -rf *" = "fg=black,bg=red";
              "rm -fr *" = "fg=black,bg=red";
            };
            styles = {
              "alias" = "fg=magenta";
            };
          };

          plugins = [
            {
              name = "zsh-completions";
              file = "zsh-completions.plugin.zsh";
              inherit (pkgs.zsh-completions) src;
            }
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
              name = "powerlevel10k-config";
              src = ./.;
              file = "p10k.zsh";
            }
          ];

          dirHashes = {
            config = "$HOME/Code/nixos";
            docs = "$HOME/Documents";
            vids = "$HOME/Videos";
            dl = "$HOME/Downloads";
          };

          history = {
            expireDuplicatesFirst = true;
            path = "$ZDOTDIR/.zsh_history";
            ignorePatterns = [
              "rm *"
              "reboot"
              "pkill *"
            ];
          };
        };
      };
    };
  };
}
