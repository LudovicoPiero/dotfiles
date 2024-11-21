{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.fish;
in
{
  options.myOptions.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    users.users.${config.myOptions.vars.username}.shell = pkgs.fish;
    programs = {
      fish.enable = true; # This settings comes from nixos options
    };

    # programs.command-not-found.enable = false;

    home-manager.users."${config.myOptions.vars.username}" =
      { config, osConfig, ... }:
      {
        # programs.nix-index.enable = true;

        home.packages = lib.attrValues {
          inherit (pkgs)
            zoxide
            fzf
            fd
            bat
            lazygit
            ;
        };

        programs.fish = {
          enable = true;
          functions = import ./functions.nix {
            inherit
              pkgs
              lib
              config
              osConfig
              ;
          };
          shellAliases = import ./shellAliases.nix { inherit pkgs lib; };
          plugins = import ./plugins.nix { inherit pkgs lib; };

          interactiveShellInit = ''
            set --global async_prompt_functions _pure_prompt_git
            set --universal pure_check_for_new_release false
            set pure_symbol_prompt "❯"

            ${_ pkgs.any-nix-shell} fish --info-right | source
          '';
        };

        programs.man.generateCaches = true; # For fish completions
      };
  };
}
