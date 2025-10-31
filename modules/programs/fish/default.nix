{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  inherit (lib) mkEnableOption mkIf optionalString;

  cfg = config.mine.fish;
in
{
  options.mine.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    users.users.root.shell = pkgs.fish;
    users.users.${config.vars.username}.shell = pkgs.fish;
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };
    environment.pathsToLink = [ "/share/fish" ];
    programs.fish.enable = true;

    hjem.extraModules = [ ./_modules.nix ];

    hj = {
      packages = with pkgs; [
        zoxide
        fzf
        fd
        bat
        lazygit
      ];
    };

    hj.mine.programs.fish = {
      enable = true;

      plugins = { inherit (pkgs.fishPlugins) tide fzf-fish; };

      earlyConfigFiles.tide = ''
        set -x tide_character_color brgreen
        set -x tide_character_color_failure brred
        set -x tide_character_icon ❯
        set -x tide_character_vi_icon_default ❮
        set -x tide_character_vi_icon_replace ▶
        set -x tide_character_vi_icon_visual V

        set -x tide_status_bg_color normal
        set -x tide_status_bg_color_failure normal
        set -x tide_status_color green
        set -x tide_status_color_failure red
        set -x tide_status_icon ✔
        set -x tide_status_icon_failure ✘

        set -x tide_prompt_add_newline_before true
        set -x tide_prompt_color_frame_and_connection 6C6C6C
        set -x tide_prompt_color_separator_same_color 949494
        set -x tide_prompt_min_cols 34
        set -x tide_prompt_pad_items false
        set -x tide_prompt_transient_enabled true

        set -x tide_left_prompt_items pwd git newline character
        set -x tide_left_prompt_frame_enabled false
        set -x tide_left_prompt_prefix
        set -x tide_left_prompt_separator_diff_color " "
        set -x tide_left_prompt_separator_same_color " "
        set -x tide_left_prompt_suffix " "

        set -x tide_right_prompt_frame_enabled false
        set -x tide_right_prompt_items status context jobs direnv node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
        set -x tide_right_prompt_prefix " "
        set -x tide_right_prompt_separator_diff_color " "
        set -x tide_right_prompt_separator_same_color " "
        set -x tide_right_prompt_suffix ""

        set -x tide_pwd_bg_color normal
        set -x tide_pwd_color_anchors brcyan
        set -x tide_pwd_color_dirs cyan
        set -x tide_pwd_color_truncated_dirs magenta
        set -x tide_pwd_icon
        set -x tide_pwd_icon_home
        set -x tide_pwd_icon_unwritable 
        set -x tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json build.zig
      '';

      config =
        with pkgs;
        ''
          function fish_greeting
          end

          set -gx GNUPGHOME $HOME/.config/gnupg
          set -gx EDITOR nvim

          alias v nvim
          alias g git
          alias c 'cd $HOME/Code/nixos'
          alias config 'cd $HOME/Code/nixos'

          . ${config.sops.secrets."shells/githubToken".path}
          ${_ nix-your-shell} fish | source
          ${_ zoxide} init fish | source
          ${_ direnv} hook fish | source
        ''
        +
          optionalString (!config.vars.withGui && config.vars.isALaptop)
            # Automatically turn off screen after 1 minute. (For laptop)
            ''
              ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
            '';
    };
  };
}
