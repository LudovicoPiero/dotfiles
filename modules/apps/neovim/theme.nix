{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim.theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
      transparent = if config.mine.vars.opacity < 1.0 then true else false;
    };
  };
}
