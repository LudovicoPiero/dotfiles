{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
in
mkIf config.mine.vars.withGui {
  hj.packages = lib.attrValues {
    inherit (pkgs) libnotify polkit_gnome;

    screenshot = pkgs.writeShellScriptBin "screenshot" ''
      DIR="$HOME/Pictures/Screenshots"
      FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
      mkdir -p "$DIR"
      ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" "$FILE"
      ${getExe' pkgs.wl-clipboard "wl-copy"} < "$FILE"
      ${getExe pkgs.libnotify} "Screenshot taken" "Saved to $FILE" -i "$FILE"
    '';

    wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
      ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - \
        | ${getExe pkgs.tesseract} - - \
        | ${getExe' pkgs.wl-clipboard "wl-copy"}
      ${getExe pkgs.libnotify} "OCR" "Text copied to clipboard"
    '';

    clipboard-picker = pkgs.writeShellScriptBin "clipboard-picker" ''
      ${getExe pkgs.cliphist} list \
        | ${getExe pkgs.rofi} -dmenu -display-columns 2 \
        | ${getExe pkgs.cliphist} decode \
        | ${getExe' pkgs.wl-clipboard "wl-copy"}
    '';

    x11-screenshot = pkgs.writeShellScriptBin "x11-screenshot" ''
      DIR="$HOME/Pictures/Screenshots"
      FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
      mkdir -p "$DIR"
      ${getExe pkgs.maim} -s "$FILE"
      ${getExe pkgs.xclip} -selection clipboard -t image/png -i "$FILE"
      ${getExe pkgs.libnotify} "Screenshot taken" "Saved to $FILE" -i "$FILE"
    '';

    x11-ocr = pkgs.writeShellScriptBin "x11-ocr" ''
      ${getExe pkgs.maim} -s | ${getExe pkgs.tesseract} - - | ${getExe pkgs.xclip} -selection clipboard
      ${getExe pkgs.libnotify} "OCR" "Text copied to clipboard"
    '';

    x11-clipboard-picker = pkgs.writeShellScriptBin "x11-clipboard-picker" ''
      ${getExe pkgs.rofi} -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
    '';

    x11-powermenu = pkgs.writeShellScriptBin "x11-powermenu" ''
      CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | ${getExe pkgs.rofi} -dmenu -i -p "Power")
      case "$CHOSEN" in
        "Lock") ${getExe pkgs.xset} s activate ;;
        "Suspend") systemctl suspend ;;
        "Reboot") systemctl reboot ;;
        "Shutdown") systemctl poweroff ;;
        "Log Out") i3-msg exit ;;
      esac
    '';
  };
}
