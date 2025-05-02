{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.theme;
in
{
  options.myOptions.theme = {
    enable = mkEnableOption "" // {
      default = config.vars.withGui;
    };

    colorScheme = mkOption {
      type = types.anything;
      default = inputs.nix-colors.colorSchemes.${config.vars.colorScheme};
    };

    gtk = {
      cursorTheme = {
        name = mkOption {
          type = types.str;
          default = "phinger-cursors-light";
        };
        size = mkOption {
          type = types.int;
          default = 24;
        };
        package = mkOption {
          type = types.package;
          default = pkgs.phinger-cursors;
        };
      };

      theme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur-Dark";
        };
        package = mkOption {
          type = types.package;
          default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
        };
      };

      iconTheme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur-dark";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.whitesur-icon-theme;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      {
        imports = [
          inputs.nix-colors.homeManagerModules.default
          ./gtk
        ];

        inherit (cfg) colorScheme;

        home = {
          packages = [ cfg.gtk.cursorTheme.package ];
          pointerCursor = {
            inherit (cfg.gtk.cursorTheme) name package size;
            hyprcursor.enable = true;
            x11.enable = true;
            gtk.enable = true;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk3";
        };

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            # Use dconf-editor to get this settings.
            color-scheme = "prefer-dark";
            cursor-theme = config.gtk.cursorTheme.name;
            cursor-size = config.gtk.cursorTheme.size;
            gtk-theme = config.gtk.theme.name;
            icon-theme = config.gtk.iconTheme.name;
            font-name = "${osConfig.myOptions.fonts.main.name} ${toString osConfig.myOptions.fonts.size}";
            clock-format = "12h";
            clock-show-date = true;
            clock-show-seconds = false;
            clock-show-weekday = false;
            enable-animations = true;
            enable-hot-corners = false;
            font-antialiasing = "grayscale";
            font-hinting = "slight";
            scaling-factor = 1;
            text-scaling-factor = 1.0;
            toolbar-style = "text";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "close,minimize,maximize:";
            resize-with-right-button = true;
            mouse-button-modifier = "<super>";
          };
        };
      }; # For Home-Manager options
  };
}
