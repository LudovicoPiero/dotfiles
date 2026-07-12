{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.dunst;
  c = config.mine.theme.colors;
in
{
  options.mine.dunst = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Dunst configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dunst;
      description = "The Dunst package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];
      xdg.config.files."dunst/dunstrc".text = ''
        [global]
            font = ${config.mine.fonts.terminal.name} ${toString config.mine.fonts.size}

            origin = top-right
            offset = 20x20
            width = 400
            height = 125

            frame_width = 2
            frame_color = "${c.base0D}"
            corner_radius = 5

            padding = 20
            horizontal_padding = 20

            background = "${c.base00}"
            foreground = "${c.base05}"

            progress_bar = true
            progress_bar_color = "${c.base02}"

            # Layer-shell placement — only relevant when dunst is running
            # under a Wayland compositor (needs a dunst build with wayland
            # support); harmless/ignored under X11 (i3, etc.).
            layer = top

        [urgency_low]
            background = "${c.base00}"
            foreground = "${c.base05}"
            frame_color = "${c.base0D}"
            timeout = 5

        [urgency_normal]
            background = "${c.base00}"
            foreground = "${c.base05}"
            frame_color = "${c.base0D}"
            timeout = 5

        [urgency_critical]
            background = "${c.base00}"
            foreground = "${c.base05}"
            frame_color = "${c.base08}"
            timeout = 0
      '';
    };
  };
}
