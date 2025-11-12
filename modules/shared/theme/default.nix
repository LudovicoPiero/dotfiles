{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mine.theme.colorScheme = {
    name = mkOption {
      type = types.str;
      default = "tokyonight-moon";
      description = "Name of the active color scheme.";
    };

    author = mkOption {
      type = types.str;
      default = "https://github.com/folke/tokyonight.nvim";
      description = "Color scheme author or source.";
    };

    palette = mkOption {
      type = types.attrsOf types.str;
      description = "Color palette used by themable applications.";
      default = {
        base00 = "222436"; # background
        base01 = "1e2030"; # darker background
        base02 = "191B29"; # darkest background
        base03 = "2f334d"; # highlight background
        base04 = "3b4261"; # gutter / weak foreground
        base05 = "c8d3f5"; # foreground text
        base06 = "828bb8"; # dimmed foreground
        base07 = "fca7ea"; # purple / accent
        base08 = "ff757f"; # red
        base09 = "ff966c"; # orange
        base0A = "ffc777"; # yellow
        base0B = "c3e88d"; # green
        base0C = "86e1fc"; # cyan
        base0D = "82aaff"; # blue
        base0E = "c099ff"; # magenta
        base0F = "4fd6be"; # teal
      };
    };
  };
}
