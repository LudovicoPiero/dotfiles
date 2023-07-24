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
        background = "${colors.base00}ff";
        text = "${colors.base07}ff";
        match = "${colors.base0E}ff";
        selection = "${colors.base08}ff";
        selection-text = "${colors.base07}ff";
        selection-match = "${colors.base07}ff";
        border = "${colors.base0E}ff";
      };
    };
  };
}
