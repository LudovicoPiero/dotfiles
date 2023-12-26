{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.mine.fish;
  _ = lib.getExe;
  inherit (lib) mkIf mkOption types;
  inherit (config.colorscheme) colors;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

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
        set pure_symbol_prompt "λ"
        set pure_color_success '#${colors.base0E}'

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
