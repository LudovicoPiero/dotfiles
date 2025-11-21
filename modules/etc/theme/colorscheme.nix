{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mine.theme.colorScheme = {
    name = mkOption {
      type = types.str;
      default = "onedark-deep";
      description = "Name of the active color scheme.";
    };

    author = mkOption {
      type = types.str;
      default = "https://github.com/navarasu/onedark.nvim";
      description = "Color scheme author or source.";
    };

    palette = mkOption {
      type = types.attrsOf types.str;
      description = "Color palette used by themable applications (OneDark Deep).";
      default = {
        base00 = "0c0e15"; # black      (Main Background)
        base01 = "1a212e"; # bg0        (Lighter Background / Status Bar)
        base02 = "21283b"; # bg1        (Selection Background)
        base03 = "283347"; # bg2        (Comments / Invisibles)
        base04 = "455574"; # grey       (Dark Foreground)
        base05 = "93a4c3"; # fg         (Main Foreground)
        base06 = "6c7d9c"; # light_grey (Light Foreground)
        base07 = "f2cc81"; # bg_yellow  (Light Background / Accent)

        base08 = "f65866"; # red
        base09 = "dd9046"; # orange
        base0A = "efbd5d"; # yellow
        base0B = "8bcd5b"; # green
        base0C = "34bfd0"; # cyan
        base0D = "41a7fc"; # blue
        base0E = "c75ae8"; # purple
        base0F = "a75ae8"; # dark_purple (or similar accent for deprecated)
      };
    };
  };
}
