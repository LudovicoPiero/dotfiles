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

    gtk =
      let
        variant = "mocha";
        accent = "pink";
        size = "standard";
      in
      {
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
            default = "catppuccin-${variant}-${accent}-${size}";
          };
          package = mkOption {
            type = types.package;
            default = pkgs.catppuccin-gtk.override {
              inherit variant size;
              accents = [ accent ];
            };
          };
        };

        iconTheme = {
          name = mkOption {
            type = types.str;
            default = "Papirus-Dark";
          };
          package = mkOption {
            type = types.package;
            default = pkgs.catppuccin-papirus-folders.override {
              inherit accent;
              flavor = variant;
            };
          };
        };
      };

    font = {
      name = mkOption {
        type = types.str;
        default = "SF Pro Rounded";
      };
      size = mkOption {
        type = types.int;
        default = 11;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, ... }:
      {
        imports = [ inputs.nix-colors.homeManagerModules.default ];

        inherit (cfg) colorScheme;

        home = {
          packages = [
            cfg.gtk.cursorTheme.package
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
          inherit (cfg) font;
          inherit (cfg.gtk) cursorTheme theme iconTheme;

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
              gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
            in
            {
              "gtk-4.0/assets".source = "${gtk4Dir}/assets";
              "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
              "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
            };

          systemDirs.data =
            let
              schema = pkgs.gsettings-desktop-schemas;
            in
            [ "${schema}/share/gsettings-schemas/${schema.name}" ];
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
