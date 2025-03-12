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
    optionalString
    ;

  cfg = config.myOptions.fish;
in
{
  options.myOptions.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    users.users.${config.myOptions.vars.username}.shell = pkgs.fish;
    sops.secrets."fish/githubToken" = {
      mode = "0444";
    };

    environment.pathsToLink = [ "/share/fish" ];

    programs = {
      fish = {
        enable = true; # This settings comes from nixos options
        interactiveShellInit =
          ''
            . ${config.sops.secrets."fish/githubToken".path}
          ''
          +
            optionalString (!config.myOptions.vars.withGui && config.myOptions.vars.isALaptop)
              # Automatically turn off screen after 1 minute. (For laptop)
              ''
                ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
              '';
      };
    };

    # programs.command-not-found.enable = false;

    home-manager.users."${config.myOptions.vars.username}" =
      {
        config,
        osConfig,
        ...
      }:
      {
        home.packages = lib.attrValues {
          inherit (pkgs)
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
            shellAliases = import ./shellAliases.nix { inherit pkgs lib; };
            plugins = import ./plugins.nix { inherit pkgs lib; };

            interactiveShellInit = ''
              set --universal async_prompt_functions starship_prompt

              ${_ pkgs.nix-your-shell} fish | source
              ${_ pkgs.starship} init fish | source
            '';
          };

          starship = {
            enable = true;
            enableFishIntegration = false; # Manual source
            settings = lib.mkDefault {
              format = lib.concatStrings [
                "$username"
                "$hostname"
                "$directory"
                "$git_branch"
                "$git_state"
                "$git_status"
                "$cmd_duration"
                "$line_break"
                "$nix_shell"
                "$python"
                "$character"
              ];

              directory.style = "blue";

              character = {
                success_symbol = "[❯](purple)";
                error_symbol = "[❯](red)";
                vimcmd_symbol = "[❮](green)";
              };

              git_branch = {
                format = "[$branch]($style)";
                style = "bright-black";
              };

              git_status = {
                format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
                style = "cyan";
                conflicted = "";
                untracked = "";
                modified = "";
                staged = "";
                renamed = "";
                deleted = "";
                stashed = "≡";
              };

              git_state = {
                format = "\([$state( $progress_current/$progress_total)]($style)\)";
                style = "bright-black";
              };

              cmd_duration = {
                format = "[$duration]($style)";
                style = "yellow";
              };

              python = {
                format = "[$virtualenv]($style) ";
                style = "bright-black";
              };

              nix_shell = {
                format = "[$name]($style)";
                style = "bright-black";
              };
            };
          };

          man.generateCaches = true; # For fish completions
          zoxide.enable = true;
        };
      };
  };
}
