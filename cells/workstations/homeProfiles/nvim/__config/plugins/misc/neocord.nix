{
  programs.nixvim = {
    plugins.neocord = {
      enable = true;
      settings = {
        auto_update = true;
        blacklist = [ ];
        client_id = "1157438221865717891";
        debounce_timeout = 10;
        editing_text = "Editing %s";
        enable_line_number = false;
        file_assets = null;
        file_explorer_text = "Browsing Files";
        git_commit_text = "Committing changes";
        global_timer = false;
        line_number_text = "Line %s out of %s";
        log_level = null;
        logo = "auto";
        logo_tooltip = null;
        main_image = "language";
        plugin_manager_text = "Managing plugins";
        reading_text = "Reading %s";
        show_time = true;
        terminal_text = "Using Terminal";
        workspace_text = "Working on %s";
      };
    };
  };
}
