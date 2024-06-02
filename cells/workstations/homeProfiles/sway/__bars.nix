{ pkgs, lib, ... }:
[
  {
    statusCommand = "${lib.getExe pkgs.i3status}";
    # statusCommand = "${lib.getExe pkgs.i3status-rust} ~/.config/i3status-rust/config-bottom.toml";
    position = "bottom";
  }
]
