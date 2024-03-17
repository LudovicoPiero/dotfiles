{
  config,
  lib,
  pkgs,
  inputs,
  userName,
  ...
}:
let
  cfg = config.mine.fish;
  _ = lib.getExe;
  inherit (lib) mkIf mkOption types;
  inherit (config.colorScheme) palette;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.mine.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable fish Shell and Set configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${userName} = {
      # programs.nix-index-database.comma.enable = true;
      # programs.nix-index.enable = true;
      programs.zoxide.enable = true;

      programs.lsd = {
        enable = true;
        enableAliases = false;
        colors = import ./lsd-colors.nix;
        settings = import ./lsd-settings.nix;
      };

      programs.fish = with pkgs; {
        enable = true;
        functions = import ./fish-functions.nix { inherit lib pkgs; };
        shellAliases = import ./fish-aliases.nix { inherit config lib pkgs; };

        interactiveShellInit = ''
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
    };
  };
}
