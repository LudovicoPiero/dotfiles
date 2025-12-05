_: {
  hj.xdg.config.files."fish/conf.d/tide_theme.fish".text = ''
    set -gx tide_character_color brgreen
    set -gx tide_character_color_failure brred
    set -gx tide_character_icon ❯
    set -gx tide_character_vi_icon_default ❮
    set -gx tide_character_vi_icon_replace ▶
    set -gx tide_character_vi_icon_visual V

    set -gx tide_status_bg_color normal
    set -gx tide_status_bg_color_failure normal
    set -gx tide_status_color green
    set -gx tide_status_color_failure red
    set -gx tide_status_icon ✔
    set -gx tide_status_icon_failure ✘

    set -gx tide_prompt_add_newline_before true
    set -gx tide_prompt_color_frame_and_connection 6C6C6C
    set -gx tide_prompt_color_separator_same_color 949494
    set -gx tide_prompt_min_cols 34
    set -gx tide_prompt_pad_items false
    set -gx tide_prompt_transient_enabled true

    set -gx tide_left_prompt_items pwd git newline character
    set -gx tide_left_prompt_frame_enabled false
    set -gx tide_left_prompt_prefix
    set -gx tide_left_prompt_separator_diff_color " "
    set -gx tide_left_prompt_separator_same_color " "
    set -gx tide_left_prompt_suffix " "

    set -gx tide_right_prompt_frame_enabled false
    set -gx tide_right_prompt_items status context jobs direnv node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
    set -gx tide_right_prompt_prefix " "
    set -gx tide_right_prompt_separator_diff_color " "
    set -gx tide_right_prompt_separator_same_color " "
    set -gx tide_right_prompt_suffix ""

    set -gx tide_pwd_bg_color normal
    set -gx tide_pwd_color_anchors brcyan
    set -gx tide_pwd_color_dirs cyan
    set -gx tide_pwd_color_truncated_dirs magenta
    set -gx tide_pwd_icon
    set -gx tide_pwd_icon_home
    set -gx tide_pwd_icon_unwritable 
    set -gx tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json build.zig
  '';
}
