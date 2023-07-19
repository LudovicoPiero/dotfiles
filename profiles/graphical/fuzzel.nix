{config, ...}: let
  cfg = config.home-manager.users."${config.vars.username}";
  gtkCfg = cfg.gtk;
  inherit (config.vars.colorScheme) colors;
in {
  home-manager.users.${config.vars.username} = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Iosevka q-16";
          terminal = "${config.vars.terminalBin}";
          icon-theme = "${gtkCfg.iconTheme.name}";
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
  };
}
