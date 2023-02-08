{
  config,
  lib,
  ...
}: {
  home-manager.users."${config.vars.username}" = {
    programs.starship = {
      enable = true;
      enableIonIntegration = false;
      enableFishIntegration = true;
      enableZshIntegration = true;

      # Pure Presets
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$character"
        ];
        command_timeout = 1000;
        # right_format = "$all";
        directory = {
          style = "blue";
        };
        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
        };
        git_branch = {
          style = "bright-black";
          format = "[$branch]($style)";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };
        git_state = {
          format = "\([$state( $progress_current/$progress_total)]($style)\)";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
          min_time = 5000;
        };
        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };
      };
    };
  };
}
