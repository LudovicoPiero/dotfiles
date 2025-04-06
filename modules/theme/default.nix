{
  lib,
  pkgs,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  mkService = lib.recursiveUpdate {
    Unit.After = [ "multi-user.target" ];
    Install.WantedBy = [ "graphical.target" ];
  };

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

    font = {
      name = mkOption {
        type = types.str;
        default = "SF Pro Rounded";
      };
      package = mkOption {
        type = types.package;
        default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.san-francisco-pro;
      };
      size = mkOption {
        type = types.int;
        default = 12;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, ... }:
      {
        imports = [
          inputs.nix-colors.homeManagerModules.default
          ./gtk
        ];

        inherit (cfg) colorScheme;

        home = {
          packages = [
            cfg.gtk.cursorTheme.package
            cfg.font.package
            pkgs.gnomeExtensions.user-themes
          ];
          pointerCursor = {
            inherit (cfg.gtk.cursorTheme) name package size;
            hyprcursor.enable = true;
            x11.enable = true;
            gtk.enable = true;
          };
        };

        # User Services
        systemd.user.services = {
          swaybg = mkService {
            Unit.Description = "Swaybg Services";
            Service = {
              ExecStart = "${lib.getExe pkgs.swaybg} -m stretch -i ${inputs.self}/assets/Lain_Red.png";
              Restart = "on-failure";
            };
          };
          wl-clip-persist = mkService {
            Unit.Description = "Keep Wayland clipboard even after programs close";
            Service = {
              ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
              Restart = "on-failure";
              Slice = "app-graphical.slice";
              TimeoutStartSec = "10s";
            };
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
            font-name = "${cfg.font.name} ${toString cfg.font.size}";
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
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" ];
          };
          "org/gnome/shell/extensions/user-theme" = { inherit (config.gtk.theme) name; };
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${self}/assets/Lain_Red.png";
            picture-uri-dark = "${self}/assets/anime-nix-wallpaper.png";
            primary-color = "#000000000000";
            secondary-color = "#000000000000";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "close,minimize,maximize:icon";
          };
        };
      }; # For Home-Manager options
  };
}
