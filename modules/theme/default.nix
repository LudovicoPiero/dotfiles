{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
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
    package = pkgs.whitesur-icon-theme;
  };

  mkService = lib.recursiveUpdate {
    Unit.After = ["multi-user.target"];
    Install.WantedBy = ["graphical.target"];
  };

  cfg = config.myOptions.theme;
in {
  options.myOptions.theme = {
    enable =
      mkEnableOption ""
      // {
        default = config.myOptions.vars.withGui;
      };

    colorScheme = mkOption {
      type = types.anything;
      default = inputs.nix-colors.colorSchemes.${config.myOptions.vars.colorScheme};
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} = {config, ...}: {
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
          package = inputs.hyprcursor-phinger.packages.${pkgs.system}.hyprcursor-phinger;
          name = lib.mkForce "phinger-cursors-light-hyprcursor";
          size = 24;
        };

        font = let
        in {
          inherit (font) name size;
        };

        theme = {
          inherit (theme) name package;
        };

        iconTheme = {
          inherit (iconsTheme) name package;
        };

        gtk2.extraConfig = ''
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

      xdg.dataFile."icons/${config.gtk.cursorTheme.name}".source = lib.mkForce "${
        inputs.hyprcursor-phinger.packages.${pkgs.system}.default
      }/share/icons/theme_phinger-cursors-light";

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
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "close,minimize,maximize:icon";
        };
      };
    }; # For Home-Manager options
  };
}
