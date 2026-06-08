{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      # Buffer tabs at top
      tabline.nvimBufferline.enable = true;

      # File icons
      visuals.nvim-web-devicons.enable = true;

      # Indent guides
      visuals.indent-blankline.enable = true;

      # Nicer UI for inputs/selects
      ui = {
        borders.enable = true;
        breadcrumbs.enable = true; # LSP breadcrumbs in winbar
        fastaction.enable = true; # Code action picker
        colorizer.enable = true; # Highlight hex color codes
        illuminate.enable = true; # Highlight word under cursor
      };

      # Notifications
      notify.nvim-notify = {
        enable = true;
        setupOpts.render = "compact";
      };

      # Nicer cmdline/messages/popupmenu (noice)
      ui.noice.enable = true;

      # Treesitter-based syntax highlighting globally
      treesitter = {
        enable = true;
        fold = false;
        grammars = [ ]; # languages add their own grammars
      };
    };
  };
}
