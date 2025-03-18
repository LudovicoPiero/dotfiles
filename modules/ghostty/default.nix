{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.ghostty;
in
{
  options.myOptions.ghostty = {
    enable = mkEnableOption "ghostty" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      let
        inherit (config) colorScheme;
        inherit (config.colorScheme) palette;
      in
      {
        programs.ghostty = {
          enable = true;
          enableFishIntegration = true;
          enableZshIntegration = true;

          settings = {
            font-family = "${osConfig.myOptions.fonts.main.name} Semibold";
            theme = "${colorScheme.slug}";
            cursor-style-blink = false;
            background-opacity = "${toString osConfig.vars.opacity}";
            shell-integration-features = "no-cursor,no-sudo,title";
            app-notifications = "no-clipboard-copy";
            gtk-single-instance = true;

            keybind = [
              "ctrl+a>c=new_tab"
              "ctrl+a>v=new_split:down"
              "ctrl+a>;=new_split:right"

              "ctrl+a>l=goto_split:right"
              "ctrl+a>h=goto_split:left"
              "ctrl+a>k=goto_split:up"
              "ctrl+a>j=goto_split:down"
            ];
          };

          themes."${colorScheme.slug}" = {
            palette = [
              "0=${palette.base00}"
              "1=${palette.base08}"
              "2=${palette.base0B}"
              "3=${palette.base0A}"
              "4=${palette.base0D}"
              "5=${palette.base0E}"
              "6=${palette.base0C}"
              "7=${palette.base05}"
              "8=${palette.base03}"
              "9=${palette.base08}"
              "10=${palette.base0B}"
              "11=${palette.base0A}"
              "12=${palette.base0D}"
              "13=${palette.base0E}"
              "14=${palette.base0C}"
              "15=${palette.base07}"
            ];
            background = palette.base00;
            foreground = palette.base05;
            cursor-color = palette.base05;
            selection-background = palette.base02;
            selection-foreground = palette.base05;
          };
        };
      }; # For Home-Manager options
  };
}
