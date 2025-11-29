{ lib, config, ... }:
let
  inherit (lib) mkIf mkAfter;

  cfgmine = config.mine;
in
mkIf cfgmine.hyprland.enable {
  hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
    monitorv2 {
      output = HDMI-A-1
      mode = 1920x1080@180
      position = auto
      scale = 1
      cm = dcip3
      supports_hdr = true
      supports_wide_color = true
      bitdepth = 10
    }

    monitorv2 {
      output = eDP-1
      disabled = true
    }

    workspace = w[tv1]s[false], gapsout:0, gapsin:0
    workspace = f[1]s[false], gapsout:0, gapsin:0
    workspace = s[true], gapsout:10, gapsin:10, rounding:true
    workspace = 1, monitor:HDMI-A-1
    workspace = 2, monitor:HDMI-A-1
    workspace = 3, monitor:HDMI-A-1
    workspace = 4, monitor:HDMI-A-1
    workspace = 5, monitor:HDMI-A-1
    workspace = 6, monitor:HDMI-A-1
    workspace = 7, monitor:HDMI-A-1
    workspace = 8, monitor:HDMI-A-1
    workspace = 9, monitor:HDMI-A-1
  '';
}
