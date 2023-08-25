{config, ...}: let
  inherit (config.colorScheme) colors;
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono-16";
        terminal = "wezterm";
        icon-theme = "${config.gtk.iconTheme.name}";
        prompt = "->";
      };

      border = {
        width = 2;
        radius = 0;
      };

      dmenu = {
        mode = "text";
      };

      colors = {
        background = "${colors.base01}f2";
        text = "${colors.base05}ff";
        match = "${colors.base0D}ff";
        selection = "${colors.base03}ff";
        selection-text = "${colors.base06}ff";
        selection-match = "${colors.base0D}ff";
        border = "${colors.base0D}ff";
      };
    };
  };
}
