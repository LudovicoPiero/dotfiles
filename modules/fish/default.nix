{
  config,
  pkgs,
  lib,
  ...
}: let
  _ = lib.getExe;

  inherit
    (lib)
    mkEnableOption
    mkIf
    optionalString
    ;

  cfg = config.myOptions.fish;
in {
  options.myOptions.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    users.users.${config.myOptions.vars.username}.shell = pkgs.fish;
    sops.secrets."fish/githubToken" = {mode = "0444";};

    environment.pathsToLink = ["/share/fish"];

    programs = {
      fish = {
        enable = true; # This settings comes from nixos options
        interactiveShellInit =
          ''
            . ${config.sops.secrets."fish/githubToken".path}
          ''
          + optionalString (!config.myOptions.vars.withGui)
          /*
          Automatically turn of screen after 1 minute. (For laptop)
          */
          ''
            ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
          '';
      };
    };

    # programs.command-not-found.enable = false;

    home-manager.users."${config.myOptions.vars.username}" = {
      config,
      osConfig,
      ...
    }: {
      home.packages = lib.attrValues {
        inherit
          (pkgs)
          zoxide
          fzf
          fd
          bat
          lazygit
          ;
      };

      programs = {
        fish = {
          enable = true;
          functions = import ./functions.nix {
            inherit
              pkgs
              lib
              config
              osConfig
              ;
          };
          shellAliases = import ./shellAliases.nix {inherit pkgs lib;};
          plugins = import ./plugins.nix {inherit pkgs lib;};

          interactiveShellInit = ''
            set --global async_prompt_functions _pure_prompt_git
            set --universal pure_check_for_new_release false
            set pure_symbol_prompt "❯"

            ${_ pkgs.any-nix-shell} fish --info-right | source
          '';
        };

        man.generateCaches = true; # For fish completions
        zoxide.enable = true;
      };
    };
  };
}
