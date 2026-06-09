{
  config,
  lib,
  inputs,
  inputs',
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.mine.noctalia;
in
{
  options.mine.noctalia = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Noctalia Shell";
    };

    package = mkOption {
      type = types.package;
      default = inputs'.noctalia.packages.default;
      description = "The Noctalia Shell package to install.";
    };

    systemd = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };

      target = mkOption {
        type = types.str;
        default = "graphical-session.target";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    hjem = {
      extraModules = [ inputs.noctalia.hjemModules.default ];
      users.${config.mine.vars.username} = {
        programs.noctalia = {
          enable = true;
          systemd = {
            inherit (cfg.systemd) enable target;
          };

          settings = {
            bar = {
              order = [ "default" ];
              default = {
                enabled = true;
                start = [
                  "launcher"
                  "workspaces"
                ];
              };
            };

            calendar = {
              enabled = true;
            };

            lockscreen_widgets = {
              enabled = false;
              schema_version = 2;
              widget_order = [ "lockscreen-login-box@HDMI-A-1" ];
              grid = {
                cell_size = 16;
                major_interval = 4;
                visible = true;
              };
              widget = {
                "lockscreen-login-box@HDMI-A-1" = {
                  box_height = 0.0;
                  box_width = 0.0;
                  cx = 960.0;
                  cy = 957.0;
                  output = "HDMI-A-1";
                  rotation = 0.0;
                  type = "login_box";
                };
              };
            };

            shell = {
              launch_apps_as_systemd_services = true;
              settings_show_advanced = true;
            };

            theme = {
              builtin = "Catppuccin";
            };

            widget = {
              workspaces = {
                hide_when_empty = true;
              };
            };
          };
        };
      };
    };
  };
}
