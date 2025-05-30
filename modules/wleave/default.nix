{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    getExe
    ;
  inherit (config.mine.theme.colorScheme) palette;

  wleaveIconPath = "${pkgs.wleave}/share/wleave/icons";

  cfg = config.mine.wleave;
in
{
  options.mine.wleave = {
    enable = mkEnableOption "wleave";

    package = mkOption {
      type = types.package;
      default = pkgs.wleave;
      description = "The wleave package to use.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      files = {
        ".config/wleave/layout".text = ''
          {
              "label" : "lock",
              "action" : "${getExe pkgs.hyprlock} --immediate --immediate-render",
              "text" : "Lock",
              "keybind" : "l"
          }
          {
              "label" : "hibernate",
              "action" : "systemctl hibernate",
              "text" : "Hibernate",
              "keybind" : "h"
          }
          {
              "label" : "logout",
              "action" : "loginctl terminate-user $USER",
              "text" : "Logout",
              "keybind" : "e"
          }
          {
              "label" : "shutdown",
              "action" : "systemctl poweroff",
              "text" : "Shutdown",
              "keybind" : "s"
          }
          {
              "label" : "suspend",
              "action" : "systemctl suspend",
              "text" : "Suspend",
              "keybind" : "u"
          }
          {
              "label" : "reboot",
              "action" : "systemctl reboot",
              "text" : "Reboot",
              "keybind" : "r"
          }
        '';

        ".config/wleave/style.css".text = ''
          * {
            background-image: none;
            font-family: "${config.mine.fonts.main.name}";
          }

          window {
            background-color: #${palette.base01};
          }

          button {
            color: #${palette.base05};
            background-color: #${palette.base00};
            border-style: solid;
            border-width: 2px;
            background-repeat: no-repeat;
            background-position: center;
          }

          button:focus,
          button:active,
          button:hover {
            background-color: #${palette.base02};
            outline-style: none;
          }

          #lock {
            background-image: url("${wleaveIconPath}/lock.svg"),
              url("${wleaveIconPath}/lock.svg");
          }

          #logout {
            background-image: url("${wleaveIconPath}/logout.svg"),
              url("${wleaveIconPath}/logout.svg");
          }

          #suspend {
            background-image: url("${wleaveIconPath}/suspend.svg"),
              url("${wleaveIconPath}/suspend.svg");
          }

          #hibernate {
            background-image: url("${wleaveIconPath}/hibernate.svg"),
              url("${wleaveIconPath}/hibernate.svg");
          }

          #shutdown {
            background-image: url("${wleaveIconPath}/shutdown.svg"),
              url("${wleaveIconPath}/shutdown.svg");
          }

          #reboot {
            background-image: url("${wleaveIconPath}/reboot.svg"),
              url("${wleaveIconPath}/reboot.svg");
          }
        '';
      };
    };
  };
}
