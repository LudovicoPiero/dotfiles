{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mine.theme.colorScheme = {
    name = mkOption {
      type = types.str;
      default = "onedark";
      description = "Name of the active color scheme.";
    };

    author = mkOption {
      type = types.str;
      default = "https://github.com/navarasu/onedark.nvim";
      description = "Color scheme author or source.";
    };

    palette = mkOption {
      type = types.attrsOf types.str;
      description = "Color palette used by themable applications.";
      default = {
        base00 = "0c0e15"; # black / darkest background
        base01 = "1a212e"; # bg0
        base02 = "21283b"; # bg1
        base03 = "283347"; # bg2 (subtle areas)
        base04 = "6c7d9c"; # light_grey (weak_fg)
        base05 = "93a4c3"; # fg (main text)
        base06 = "f2cc81"; # bg_yellow (bright accent)
        base07 = "c75ae8"; # purple (brightest accent)

        base08 = "f65866"; # red
        base09 = "dd9046"; # orange
        base0A = "efbd5d"; # yellow
        base0B = "8bcd5b"; # green
        base0C = "34bfd0"; # cyan
        base0D = "41a7fc"; # blue
        base0E = "c75ae8"; # purple/magenta
        base0F = "455574"; # grey (alt tone)
      };
    };
  };
}
