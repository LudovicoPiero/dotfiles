{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  inherit (lib)
    mkForce
    mkEnableOption
    mkIf
    optionalString
    ;

  cfg = config.myOptions.fish;
in
{

  imports = [
    ./functions.nix
    ./shellAliases.nix
  ];

  options.myOptions.fish = {
    enable = mkEnableOption "Fish Shell" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    users.users.root.shell = pkgs.fish;
    users.users.${config.vars.username}.shell = pkgs.fish;
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };
    environment.pathsToLink = [ "/share/fish" ];
    programs.fish = {
      enable = true;
      shellAliases = mkForce { };
      interactiveShellInit =
        ''
          . ${config.sops.secrets."shells/githubToken".path}
        ''
        + optionalString (!config.vars.withGui && config.vars.isALaptop) ''
          ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
        '';

    };

    hj = {
      packages = with pkgs; [
        zoxide
        fzf
        fd
        bat
        lazygit
      ];

      rum.programs = {
        fish = {
          enable = true;

          config = with pkgs; ''
            function fish_greeting
            end

            set --universal async_prompt_functions starship_prompt

            ${_ nix-your-shell} fish | source
            ${_ zoxide} init fish | source
            ${_ direnv} hook fish | source
            ${_ starship} init fish | source
          '';

          plugins = {
            inherit (pkgs.fishPlugins) async-prompt;
          };
        };

        starship = {
          enable = true;
          settings = lib.mkDefault {
            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$directory"
              "$git_branch"
              "$git_state"
              "$git_status"
              " "
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
              format = "[[(*$conflicted $untracked $modified $staged $renamed $deleted)](218) ($ahead_behind $stashed)]($style)";
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
      };
    };
  };
}
