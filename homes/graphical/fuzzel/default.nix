{config, ...}: let
  inherit (config.colorScheme) colors;
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka q-16";
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
        background = "${colors.base00}f2";
        text = "${colors.base05}ff";
        match = "${colors.base0A}ff";
        selection = "${colors.base03}ff";
        selection-text = "${colors.base05}ff";
        selection-match = "${colors.base0A}ff";
        border = "${colors.base0D}ff";
      };
    };
  };
}
