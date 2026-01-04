{ lib, ... }:
let
  inherit (lib) mkOption types;

  mkColor =
    default:
    mkOption {
      type = types.str;
      inherit default;
      description = "Base16 color hex code (e.g. #FF0000)";
    };
in
{
  options.mine.theme = {
    name = mkOption {
      type = types.str;
      default = "tokyo-night";
      description = "Name of the current theme";
    };

    # Tokyo Night Palette (Base16)
    colors = {
      base00 = mkColor "#1a1b26"; # Default Background
      base01 = mkColor "#24283b"; # Lighter Background (Status bars)
      base02 = mkColor "#414868"; # Selection Background
      base03 = mkColor "#565f89"; # Comments, Invisibles, Line Highlighting
      base04 = mkColor "#a9b1d6"; # Dark Foreground (Status bars)
      base05 = mkColor "#c0caf5"; # Default Foreground, Caret, Delimiters
      base06 = mkColor "#c0caf5"; # Light Foreground (Not often used)
      base07 = mkColor "#c0caf5"; # Light Background (Not often used)

      base08 = mkColor "#f7768e"; # Red (Variables, XML Tags, Diff Deleted)
      base09 = mkColor "#ff9e64"; # Orange (Integers, Boolean, Constants)
      base0A = mkColor "#e0af68"; # Yellow (Classes, Search Text)
      base0B = mkColor "#9ece6a"; # Green (Strings, Diff Inserted)
      base0C = mkColor "#7dcfff"; # Cyan (Support, Regex, Escape Characters)
      base0D = mkColor "#7aa2f7"; # Blue (Functions, Methods, Headings)
      base0E = mkColor "#bb9af7"; # Purple (Keywords, Storage, Diff Changed)
      base0F = mkColor "#db4b4b"; # Brown (Deprecated, Embedded Tags)
    };
  };
}
