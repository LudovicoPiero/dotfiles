{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf mkAfter;
  cfg = config.mine.hyprland;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
      exec-once = ${getExe pkgs.hypridle}
    '';

    hj.xdg.config.files."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || ${getExe pkgs.hyprlock}
          before_sleep_cmd = loginctl lock-session
          # Checks if Sway is running; if yes, uses swaymsg, otherwise defaults to hyprctl
          after_sleep_cmd = if pgrep -x sway; then swaymsg "output * power on"; else hyprctl dispatch dpms on; fi
      }

      listener {
          timeout = 150
          on-timeout = ${lib.getExe pkgs.brightnessctl} -s set 10
          on-resume = ${lib.getExe pkgs.brightnessctl} -r
      }

      listener {
          timeout = 300
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 330
          # Sway uses "output * power off", Hyprland uses "dispatch dpms off"
          on-timeout = if pgrep -x sway; then swaymsg "output * power off"; else hyprctl dispatch dpms off; fi
          on-resume = if pgrep -x sway; then swaymsg "output * power on"; else hyprctl dispatch dpms on; fi
      }

      # listener {
      #     timeout = 1800 # 30min
      #     on-timeout = systemctl suspend
      # }
    '';
  };
}
