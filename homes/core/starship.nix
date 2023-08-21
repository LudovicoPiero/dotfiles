{lib, ...}: {
  programs.starship = {
    enable = true;
    enableIonIntegration = false;
    enableFishIntegration = true;
    enableZshIntegration = true;

    # Pure Presets
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$cmd_duration"
        "$git_metrics"
        "$git_state"
        "$git_branch"
        "$line_break"
        "$status"
        "$directory"
        "$character"
      ];
      right_format = lib.concatStrings [
        "$sudo"
        "$nix_shell"
        "\${custom.direnv}"
        "$time"
      ];
      continuation_prompt = "▶ ";
      command_timeout = 1000;
      # right_format = "$all";
      directory = {
        style = "blue";
      };
      character = {
        success_symbol = "[λ](purple)";
        error_symbol = "[λ](red)";
      };
      git_branch = {
        style = "bright-black";
        format = "[$branch]($style)";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\)";
        style = "bright-black";
      };
      nix_shell = {
        format = "[󱄅 ](cyan)";
        heuristic = true;
      };
      sudo = {
        format = "[ ](red)";
        disabled = false;
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
        min_time = 5000;
      };
    };
  };
}
