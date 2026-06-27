{ config, lib, ... }: {
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      mini = {
        ai = {
          enable = true;
          setupOpts.n_lines = 500;
        };
        splitjoin.enable = true;
        surround.enable = true;

        statusline = {
          enable = true;
          setupOpts = {
            statusline.section_location = ''
              return "%2l:%-2v"
            '';
          };
        };
      };
    };
  };
}
