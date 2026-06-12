{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      presence.neocord = {
        enable = true;
        setupOpts = {
          enable_line_number = true;
          file_explorer_text = "Browsing %s";
        };
      };
    };
  };
}
