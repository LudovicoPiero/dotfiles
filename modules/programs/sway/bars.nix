{ lib, config, ... }:
let
  inherit (lib) getExe;
  inherit (config.mine.theme.colorScheme) palette;
in
{
  hm =
    { config, osConfig, ... }:
    {
      wayland.windowManager.sway.config.bars = [
        {
          command = "${getExe config.programs.waybar.package}";
          position = "bottom";

          fonts = {
            names = [ "${osConfig.mine.fonts.terminal.name}" ];
            size = 10.0;
          };
          colors = {
            background = "#${palette.base00}";
            separator = "#${palette.base04}";
            statusline = "#${palette.base05}";
            focusedWorkspace = {
              border = "#${palette.base05}";
              background = "#${palette.base0D}";
              text = "#${palette.base00}";
            };
            activeWorkspace = {
              border = "#${palette.base05}";
              background = "#${palette.base03}";
              text = "#${palette.base05}";
            };
            inactiveWorkspace = {
              border = "#${palette.base03}";
              background = "#${palette.base01}";
              text = "#${palette.base05}";
            };
            urgentWorkspace = {
              border = "#${palette.base08}";
              background = "#${palette.base08}";
              text = "#${palette.base00}";
            };
            bindingMode = {
              border = "#${palette.base00}";
              background = "#${palette.base0A}";
              text = "#${palette.base00}";
            };
          };
        }
      ];
    };
}
