{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mine.theme.colorScheme = {
    name = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      description = "Name of the active color scheme.";
    };

    author = mkOption {
      type = types.str;
      default = "https://github.com/catppuccin/catppuccin";
      description = "Color scheme author or source.";
    };

    palette = mkOption {
      type = types.attrsOf types.str;
      description = "Color palette used by themable applications (Catppuccin mocha).";
      default = {
        base00 = "1e1e2e"; # bg          (Main Background)
        base01 = "181825"; # base3       (Lighter Background / Region)
        base02 = "313244"; # base4       (Selection Background)
        base03 = "45475a"; # base5       (Comments / Invisibles)
        base04 = "585b70"; # base8       (Dark Foreground)
        base05 = "cdd6f4"; # fg          (Main Foreground)
        base06 = "f5e0dc"; # fg-alt      (Light Foreground)
        base07 = "b4befe"; # white       (Light Background / Accent)

        base08 = "f38ba8"; # red
        base09 = "fab387"; # orange
        base0A = "f9e2af"; # yellow
        base0B = "a6e3a1"; # green
        base0C = "94e2d5"; # cyan
        base0D = "89b4fa"; # blue
        base0E = "cba6f7"; # magenta
        base0F = "f2cdcd"; # violet
      };
    };
  };
}
