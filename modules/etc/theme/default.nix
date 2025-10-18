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

  inherit (inputs) self;

  wallpaperLink = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/0p/wallhaven-0pom5m.jpg";
    hash = "sha256-WHt/fDfCHlS4VZp+lydSHm8f7Pa0trf3WoiCCmG8Ih0=";
  };

  cfg = config.mine.theme;
in
{
  options.mine.theme = {
    enable = mkEnableOption "Theme";

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
          default = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
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
    hm =
      { config, osConfig, ... }:
      {
        imports = [ inputs.nix-colors.homeManagerModules.default ];
        inherit (cfg) colorScheme;

        systemd.user.services.swaybg = {
          Unit = {
            Description = "Wayland wallpaper daemon";
            After = [ "graphical-session.target" ];
            BindsTo = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            Type = "simple";
            Restart = "on-failure";
            ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaperLink}";
          };
        };

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

        gtk = {
          enable = true;

          font = {
            inherit (osConfig.mine.fonts.main) name package;
            inherit (osConfig.mine.fonts) size;
          };

          inherit (cfg.gtk) cursorTheme theme iconTheme;

          gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
          gtk3.bookmarks = [
            "file://${config.home.homeDirectory}/Code"
            "file://${config.home.homeDirectory}/Media"
            "file://${config.home.homeDirectory}/Documents"
            "file://${config.home.homeDirectory}/Downloads"
            "file://${config.home.homeDirectory}/Music"
            "file://${config.home.homeDirectory}/Pictures"
            "file://${config.home.homeDirectory}/Videos"
            "file://${config.home.homeDirectory}/WinE"
          ];
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
            # Use dconf-editor to get these settings.
            color-scheme = "prefer-dark";
            cursor-theme = config.gtk.cursorTheme.name;
            cursor-size = config.gtk.cursorTheme.size;
            gtk-theme = config.gtk.theme.name;
            icon-theme = config.gtk.iconTheme.name;
            font-name = "${osConfig.mine.fonts.main.name} ${toString osConfig.mine.fonts.size}";
            document-font-name = "${osConfig.mine.fonts.main.name} ${toString osConfig.mine.fonts.size}";
            monospace-font-name = "${osConfig.mine.fonts.main.name} ${toString osConfig.mine.fonts.size}";
            clock-format = "12h";
            clock-show-date = true;
            clock-show-seconds = false;
            clock-show-weekday = false;
            enable-animations = true;
            enable-hot-corners = false;
            font-antialiasing = "rgba";
            font-hinting = "full";
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
      };
  };
}
