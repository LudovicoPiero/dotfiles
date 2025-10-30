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

  cfg = config.mine.fish;
in
{

  imports = [
    ./direnv.nix
    ./functions.nix
    ./shellAliases.nix
  ];

  options.mine.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    users.users.${config.vars.username} = {
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
    };
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };
    environment.pathsToLink = [ "/share/fish" ];
    programs = {
      fish = {
        enable = false;
        useBabelfish = true;
        shellAliases = mkForce { };
      };

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          prettybat
        ];
        settings = {
          pager = "less";
          theme = "OneHalfDark";
        };
      };
    };

    hm =
      { osConfig, ... }:
      {
        home.packages = with pkgs; [
          zoxide
          fzf
          fd
          lazygit
        ];

        programs = {
          fish = {
            enable = true;

            #NOTE: get default tide config using `set -U | grep tide_`
            interactiveShellInit =
              with pkgs;
              ''
                function fish_greeting
                end

                . ${osConfig.sops.secrets."shells/githubToken".path}

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

                ${_ zoxide} init fish | source
                ${_ nix-your-shell} fish | source
              ''
              + optionalString (!osConfig.vars.withGui && osConfig.vars.isALaptop) ''
                ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
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
                name = "tide";
                src = pkgs.fetchFromGitHub {
                  owner = "IlanCosman";
                  repo = "tide";
                  rev = "44c521ab292f0eb659a9e2e1b6f83f5f0595fcbd";
                  hash = "sha256-85iU1QzcZmZYGhK30/ZaKwJNLTsx+j3w6St8bFiQWxc=";
                };
              }
            ];
          };
        };
      };
  };
}
