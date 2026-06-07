{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    getExe
    getExe'
    strip
    ;
  cfg = config.mine.hyprland;
  c = config.mine.theme.colors;
in
{
  options.mine.hyprland = {
    enable = mkEnableOption "Hyprland compositor";
    package = mkOption {
      type = lib.types.package;
      default = inputs'.hyprland.packages.hyprland;
      description = "The Hyprland package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;
        inherit (cfg) package;
        portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
      };
    };
    security.pam.services.hypridle.text = "auth include login";

    mine.waybar = {
      enable = true;
      wm = "hyprland";
    };

    hj.xdg.config.files = {
      "hypr/hyprland.lua".text = ''
        require("lua.monitors")
        require("lua.env")
        require("lua.autostart")
        require("lua.options")
        require("lua.keybinds")
        require("lua.rules")
      '';

      "hypr/lua/monitors.lua".text = ''
        hl.monitor({
            output   = "HDMI-A-1",
            mode     = "1920x1080@180",
            position = "auto",
            scale    = "1",
            bitdepth = 10
        })
        hl.monitor({
            output  = "eDP-1",
            disabled = true
        })
      '';

      "hypr/lua/env.lua".text = ''
        hl.env("QT_QPA_PLATFORM", "wayland;xcb")
        hl.env("GDK_BACKEND", "wayland,x11,*")
        hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
        hl.env("XDG_SESSION_TYPE", "wayland")
        hl.env("XDG_SESSION_DESKTOP", "Hyprland")
        hl.env("HYPRCURSOR_THEME", "Future-Cyan-Hyprcursor_Theme")
        hl.env("XCURSOR_THEME", "Future-Cyan-Hyprcursor_Theme")
        hl.env("XCURSOR_SIZE", "24")
        hl.env("QT_IM_MODULE", "fcitx")
        hl.env("XMODIFIERS", "@im=fcitx")
        hl.env("QT_IM_MODULES", "wayland;fcitx")
      '';

      "hypr/lua/autostart.lua".text = ''
        hl.on("hyprland.start", function ()
            hl.exec_cmd("hyprctl setcursor Future-Cyan-Hyprcursor_Theme 24")
            hl.exec_cmd("fcitx5 -d --replace")
            hl.exec_cmd("${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png")
            hl.exec_cmd("sleep 1; ${getExe pkgs.waybar}")
            hl.exec_cmd("${getExe pkgs.brightnessctl} set 10%")
            hl.exec_cmd("${getExe pkgs.mako}")
            hl.exec_cmd("${getExe pkgs.emacs} --daemon")
            hl.exec_cmd("${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store")
            hl.exec_cmd("${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store")
            hl.exec_cmd("[workspace 5 silent;noanim] ${getExe pkgs.thunderbird}")
        end)
      '';

      "hypr/lua/options.lua".text = ''
        hl.config({
            general = {
                border_size = 2,
                col = {
                    active_border = "rgb(${strip c.base0D})",
                    inactive_border = "rgb(${strip c.base02})",
                },
                gaps_in = 2,
                gaps_out = 2,
                layout = "dwindle",
            },
            decoration = {
                rounding = 0,
                dim_inactive = false,
                dim_strength = 0.7,
                blur = {
                    enabled = true,
                    passes = 2,
                    size = 2,
                    new_optimizations = true,
                    xray = true,
                    ignore_opacity = true,
                },
                shadow = {
                    enabled = false,
                },
            },
            input = {
                follow_mouse = 1,
                kb_layout = "us",
                kb_options = "ctrl:nocaps",
                repeat_delay = 300,
                repeat_rate = 30,
                touchpad = {
                    disable_while_typing = true,
                    natural_scroll = true,
                },
            },
            dwindle = {
                force_split = 2,
                preserve_split = true,
            },
            group = {
                col = {
                    border_active = "rgb(${strip c.base0D})",
                    border_inactive = "rgb(${strip c.base02})",
                },
                groupbar = {
                    col = {
                        active = "rgb(${strip c.base0D})",
                        inactive = "rgb(${strip c.base02})",
                    },
                    render_titles = false,
                    text_color = "rgb(${strip c.base05})",
                },
            },
            misc = {
                background_color = "rgb(${strip c.base00})",
                disable_hyprland_logo = false,
                disable_splash_rendering = true,
                force_default_wallpaper = -1,
            },
            xwayland = {
                force_zero_scaling = true,
            },
        })

        hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
        hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })

        hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
        hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
        hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
        hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
        hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "default" })
        hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "default", style = "fade" })
      '';
    };
  };
}
