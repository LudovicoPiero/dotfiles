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

  font = {
    name = "SF Pro Rounded";
    size = 11;
  };

  theme = {
    name = "WhiteSur-Dark";
    package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.whitesur-gtk-theme;
  };

  iconsTheme = {
    name = "WhiteSur-dark";
    package = pkgs.whitesur-icon-theme.overrideAttrs {
      dontCheckForBrokenSymlinks = true;
    };
  };

  mkService = lib.recursiveUpdate {
    Unit.After = [ "multi-user.target" ];
    Install.WantedBy = [ "graphical.target" ];
  };

  cfg = config.myOptions.theme;
in
{
  options.myOptions.theme = {
    enable = mkEnableOption "" // {
      default = config.myOptions.vars.withGui;
    };

    colorScheme = mkOption {
      type = types.anything;
      default = inputs.nix-colors.colorSchemes.${config.myOptions.vars.colorScheme};
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} =
      { config, ... }:
      {
        imports = [
          inputs.nix-colors.homeManagerModules.default
        ];

        inherit (cfg) colorScheme;

        home = {
          packages = [
            inputs.hyprcursor-phinger.packages.${pkgs.system}.default
          ];
          pointerCursor = {
            inherit (config.gtk.cursorTheme) name package size;
            x11.enable = true;
            gtk.enable = true;
          };
        };

        # User Services
        systemd.user.services = {
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

        gtk = {
          enable = true;

          cursorTheme = {
            package = pkgs.phinger-cursors;
            name = "phinger-cursors-light";
            size = 24;
          };

          font = {
            inherit (font) name size;
          };

          theme = {
            inherit (theme) name package;
          };

          iconTheme = {
            inherit (iconsTheme) name package;
          };

          gtk2 = {
            configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
            extraConfig = ''
              gtk-cursor-theme-name="${config.gtk.cursorTheme.name}"
              gtk-cursor-theme-size=${toString config.gtk.cursorTheme.size}
              gtk-toolbar-style=GTK_TOOLBAR_BOTH
              gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
              gtk-button-images=1
              gtk-menu-images=1
              gtk-enable-event-sounds=1
              gtk-enable-input-feedback-sounds=1
              gtk-xft-antialias=1
              gtk-xft-hinting=1
              gtk-xft-hintstyle="hintfull"
              gtk-xft-rgba="rgb"
            '';
          };
          gtk3 = {
            bookmarks = [
              "file://${config.home.homeDirectory}/Code"
              "file://${config.home.homeDirectory}/Media"
              "file://${config.home.homeDirectory}/Documents"
              "file://${config.home.homeDirectory}/Downloads"
              # "file://${config.home.homeDirectory}/Games"
              "file://${config.home.homeDirectory}/Music"
              "file://${config.home.homeDirectory}/Pictures"
              "file://${config.home.homeDirectory}/Videos"
              "file://${config.home.homeDirectory}/WinE"
            ];

            extraConfig = {
              gtk-application-prefer-dark-theme = 1;
              gtk-cursor-theme-name = config.gtk.cursorTheme.name;
              gtk-cursor-theme-size = config.gtk.cursorTheme.size;
              gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
              gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
              gtk-button-images = 1;
              gtk-menu-images = 1;
              gtk-enable-event-sounds = 1;
              gtk-enable-input-feedback-sounds = 1;
              gtk-xft-antialias = 1;
              gtk-xft-hinting = 1;
              gtk-xft-hintstyle = "hintfull";
              gtk-xft-rgba = "rgb";
            };
          };

          gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk3";
        };

        xdg = {
          # Stolen from https://github.com/khaneliman/khanelinix/blob/e0039561cfaa7810325ecd811e672ffa6d96736f/modules/home/theme/gtk/default.nix#L150
          configFile =
            let
              gtk4Dir = "${theme.package}/share/themes/${theme.name}/gtk-4.0";
            in
            {
              "gtk-4.0/assets".source = "${gtk4Dir}/assets";
              "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
              "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
            };

          dataFile = {
            "icons/phinger-cursors-light-hyprcursor".source = "${
              inputs.hyprcursor-phinger.packages.${pkgs.system}.default
            }/share/icons/theme_phinger-cursors-light";
          };

          systemDirs.data =
            let
              schema = pkgs.gsettings-desktop-schemas;
            in
            [ "${schema}/share/gsettings-schemas/${schema.name}" ];
        };

        home.file.".icons/default/index.theme".text = ''
          [icon theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${config.gtk.cursorTheme.name}

          [X-GNOME-Metatheme]
          GtkTheme=${theme.name}
          MetacityTheme=${theme.name}
          IconTheme=${iconsTheme.name}
          CursorTheme=${config.gtk.cursorTheme.name}
          ButtonLayout=close,minimize,maximize:menu
        '';

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            # Use dconf-editor to get this settings.
            color-scheme = "prefer-dark";
            cursor-theme = config.gtk.cursorTheme.name;
            cursor-size = config.gtk.cursorTheme.size;
            gtk-theme = theme.name;
            icon-theme = iconsTheme.name;
            font-name = "${font.name} ${toString font.size}";
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
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${self}/assets/anime-nix-wallpaper.png";
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
